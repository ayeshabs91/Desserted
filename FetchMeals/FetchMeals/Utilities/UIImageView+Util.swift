//
//  UIImageView+Util.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/9/23.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()
let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

extension UIImageView {
    
    func downloadImage(from url : String, placeholder: UIImage? = nil) {
        self.image = nil
        activityView.center = self.center
        self.addSubview(activityView)
        activityView.startAnimating()

        // check cached image
        if let cachedImage = imageCache.object(forKey: url as NSString) as? UIImage {
            self.image = cachedImage
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            return
        }

        // download image from url
        APIManager().downloadImage(from: url) { [weak self] result in
            switch result {
            case .failure(let error):
                guard let self = self else { return }
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.image = placeholder
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                }
            case .success(let image):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.image = image
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                }
            }
        }
    }
}
