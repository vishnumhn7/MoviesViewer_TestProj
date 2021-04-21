//
//  UIViewController+Extension.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 21/04/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showActivityIndicator() -> UIActivityIndicatorView{
        let activityView = UIActivityIndicatorView(style: .medium)
        let screenBounds = UIScreen.main.bounds
        activityView.frame = CGRect(x: screenBounds.size.width/2 - 12 , y: screenBounds.size.height/2 - 12, width: 24, height: 24)
        self.view.addSubview(activityView)
        activityView.startAnimating()
        return activityView
    }
    
    func removeActivityIndicator(indicator:UIActivityIndicatorView) {
        DispatchQueue.main.async {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}

