//
//  InstructionRow.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/8/23.
//

import Foundation
import UIKit

/**
 Cell view to display recipe Instructions
 */
class InstructionRow: UITableViewCell {

    private let instructionLabel = UILabel()
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15.0
        stackView.distribution = .fill
        contentView.addSubview(stackView)
        embed(childView: stackView, in: contentView,
              insets: UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: -20.0))

        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.numberOfLines = 0
        stackView.addArrangedSubview(instructionLabel)
    }
    
    func configure(with instruction: String) {
        instructionLabel.text = instruction
    }
}
