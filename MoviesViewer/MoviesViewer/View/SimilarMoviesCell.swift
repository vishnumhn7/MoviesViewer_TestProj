//
//  SimilarMoviesCell.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 21/04/21.
//

import Foundation
import UIKit

class SimilarMoviesCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    var movie: SimilarMovieResults? {
      didSet {
        releaseDate.text = "Release Date \n" + (movie?.release_date ??  "")
        titleLabel.text = movie?.title
        subtitleLabel.text = movie?.overview ?? ""
        guard let imageUrl = movie?.poster_path else { return }
        thumbnailView.loadImageUsingCacheWithURLString("https://image.tmdb.org/t/p/w500\(imageUrl)", placeHolder: nil)
      }
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
      setupCellUI()
    }
    
    func setupCellUI() {
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowOffset = .zero
        outerView.layer.shadowRadius = 4
    }
    
    @IBAction func bookButtonAction(_ sender: Any) {
        
    }

}
