//
//  ViewController.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: movieListViewControllerDelegate?
    private lazy var dataSource = makeDataSource()
    private var sections: [Section] = [] {
        didSet {
            self.applySnapshot(animatingDifferences: true)
        }
    }
    private var searchController = UISearchController(searchResultsController: nil)
    var viewModel: ViewModelling!
    private var showOnlyRecentSearch = false
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addPullToRefresh()
        self.collectionView.delegate = self
        configureSearchController()
        configureLayout()
        let activityIndicator = showActivityIndicator()
        viewModel.sections.bind { (sections) in
            self.sections = sections
        }
        viewModel.getNowPlaying { (success) in
            self.removeActivityIndicator(indicator: activityIndicator)
        }
    }
    
    func addPullToRefresh() {
        let refControl = UIRefreshControl()
        refControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refControl.tintColor = UIColor.black
        refControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refControl)
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            let activityIndicator = self.showActivityIndicator()
            self.viewModel.getNowPlaying { (success) in
                DispatchQueue.main.async {
                    refreshControl.endRefreshing()
                    self.removeActivityIndicator(indicator: activityIndicator)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Functions
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, video) ->
                UICollectionViewCell? in
                if self.showOnlyRecentSearch {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "SearchResultCollectionViewCell",
                        for: indexPath) as? SearchResultCollectionViewCell
                    cell?.movie = video
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "MovieCollectionViewCell",
                        for: indexPath) as? MovieCollectionViewCell
                    cell?.movie = video
                    return cell
                }
        })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath) as? SectionHeaderReusableView
            view?.titleLabel.text = section.title
            return view
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.videos, toSection: section)
        }
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
    
    private func selectedMovie(indexPath: IndexPath) -> Movie? {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        return movie
    }
}

extension ViewController:UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showOnlyRecentSearch = true
        viewModel.updateSearchResults(with: "", showRecentSearch:true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showOnlyRecentSearch = searchText.count > 0 ? false : true
        guard let text = searchController.searchBar.text else { return }
        viewModel.updateSearchResults(with: text, showRecentSearch:showOnlyRecentSearch)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showOnlyRecentSearch = false
        searchBar.text = ""
        searchBar.showsCancelButton = true
        viewModel.updateSearchResults(with: "", showRecentSearch:showOnlyRecentSearch)
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    private func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - Layout Handling
extension ViewController {
    private func configureLayout() {
        self.collectionView.register(UINib(nibName:"MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.collectionView.register(UINib(nibName:"SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        collectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let height = self.viewModel.height(sectionIndex: sectionIndex)
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? height : 60)
            )
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            // Supplementary header view setup
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource Implementation
extension ViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let movie = selectedMovie(indexPath: indexPath) else { return }
        delegate?.viewControllerDidSelectMovie(movie)
        viewModel.itemTapped(movie: movie)
    }
}
