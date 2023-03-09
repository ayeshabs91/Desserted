//
//  UIView+Util.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/9/23.
//

import Foundation
import UIKit

extension UIView {
    
    func embed(childView: UIView, in parentView: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: insets.top),
            childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: insets.left),
            childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: insets.right),
            parentView.bottomAnchor.constraint(equalTo: childView.bottomAnchor, constant: insets.bottom)
        ])
    }
}

