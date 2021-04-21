//
//  SearchResultCollectionViewCell.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }
    
    var movie: Movie? {
        didSet {
            titleLabel.text = movie?.title
        }
    }
    
    func setupCellUI() {
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = .zero
        titleLabel.layer.shadowRadius = 4
    }
    
}
