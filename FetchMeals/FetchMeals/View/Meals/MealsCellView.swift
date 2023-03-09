//
//  MealsCellView.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation
import UIKit

class MealsCellView: UITableViewCell {
    
    private let stackView = UIStackView()
    private let titleLabelView = UILabel()
    private let mealImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackview() {
        // Stackview
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.spacing = 10.0
        contentView.addSubview(stackView)
        embed(childView: stackView, in: contentView,
              insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: -10))
        
        // Meal Image
        mealImageView.layer.cornerRadius = 15.0
        mealImageView.layer.masksToBounds = true
        mealImageView.contentMode = .center
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Image constraints
        let size = UIScreen.main.bounds.size.width
        let widthConstraint = mealImageView.widthAnchor.constraint(equalToConstant: size)
        widthConstraint.priority = .defaultLow
        widthConstraint.isActive = true
        mealImageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        stackView.addArrangedSubview(mealImageView)
        
        // Meal title
        titleLabelView.numberOfLines = 1
        titleLabelView.textColor = UIColor.black
        titleLabelView.font = .boldSystemFont(ofSize: 20.0)
        titleLabelView.contentMode = .center
        stackView.addArrangedSubview(titleLabelView)
    }
    
    func configure(with meal: Meal) {
        
        // Title
        titleLabelView.text = meal.strMeal
                
        //Image
        mealImageView.downloadImage(from: meal.strMealThumb)
    }
}
