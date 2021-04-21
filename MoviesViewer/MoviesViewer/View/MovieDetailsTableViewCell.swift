//
//  MovieDetailsTableViewCell.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 21/04/21.
//

import Foundation
import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var movieSynopsis: Synopsis? {
      didSet {
        releaseDate.text = movieSynopsis?.tagline
        titleLabel.text = movieSynopsis?.title
        subtitleLabel.text = movieSynopsis?.overview ?? ""
        guard let imageUrl = movieSynopsis?.posterPath else { return }
        thumbnailView.loadImageUsingCacheWithURLString("https://image.tmdb.org/t/p/w500\(imageUrl)", placeHolder: nil)
      }
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
      setupCellUI()
    }
    
    func setupCellUI() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 4
    }
}

