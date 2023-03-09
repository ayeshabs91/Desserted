//
//  IngredientRow.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation
import UIKit

/**
 Cell view to display recipe Ingredients
 */
class IngredientRow: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let measurementLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
    }
    
    func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        contentView.addSubview(stackView)
        embed(childView: stackView, in: contentView,
              insets: UIEdgeInsets(top: 5, left: 20.0, bottom: 5, right: -20.0))
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(measurementLabel)
    }
    
    func configure(with ingredient: Ingredient) {
        nameLabel.text = ingredient.name
        measurementLabel.text = ingredient.measurement
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
