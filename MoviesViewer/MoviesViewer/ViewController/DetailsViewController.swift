//
//  DetailsViewController.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewModelling!
    @IBOutlet weak var tableView: UITableView!
    
    private var sections: [DetailsSection] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        viewModel.sections.bind { (sections) in
            self.sections = sections
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSynopsis()
        //viewModel.getReviews()
        //viewModel.getCredits()
        viewModel.getSimilarMovies()
    }
}

// MARK: - UITableView Delegates
extension DetailsViewController : UITableViewDataSource {
    
    func headerViewForSimilarMoviesSection() -> UIView {
        let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width, height: 25))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width, height: 25))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Similar Movies"
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = self.sections[section]
        switch sectionData.sectionType {
        case .moviedetails: return nil
        case .similarMovies: return sectionData.similarMovies?.count ?? 0 > 0 ? headerViewForSimilarMoviesSection() : nil
        case .none: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionData = self.sections[section]
        switch sectionData.sectionType {
        case .moviedetails: return 0
        case .similarMovies: return sectionData.similarMovies?.count ?? 0 > 0 ? 25 : 0
        case .none: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionData = self.sections[section]
        switch sectionData.sectionType {
        case .moviedetails: return ""
        case .similarMovies: return "Similar Movies"
        case .none: return ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = self.sections[section]
        switch sectionData.sectionType {
        case .moviedetails: return 1
        case .similarMovies: return sectionData.similarMovies?.count ?? 0
        case .none: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = self.sections[indexPath.section]
        switch sectionData.sectionType {
        case .moviedetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsTableViewCell",
                                                     for: indexPath) as! MovieDetailsTableViewCell
            cell.movieSynopsis = sectionData.synopsis?[indexPath.row]
            return cell
        case .similarMovies:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarMoviesCell",
                                                     for: indexPath) as! SimilarMoviesCell
            cell.movie = sectionData.similarMovies?[indexPath.row]
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension DetailsViewController : UITableViewDelegate {
    
}

extension DetailsViewController {
    private func configureTableView() {
        self.tableView.register(UINib(nibName: "MovieDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailsTableViewCell")
        self.tableView.register(UINib(nibName: "SimilarMoviesCell", bundle: nil), forCellReuseIdentifier: "SimilarMoviesCell")
    }
}
