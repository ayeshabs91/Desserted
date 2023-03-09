//
//  RecipeViewController.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation
import UIKit


/**
Screen to display recipe of a selected meal
 */
class RecipeViewController: UIViewController {
    
    private let viewModel: RecipeViewModel
    private let tableview: UITableView
    private let imageView: UIImageView
    
    init(for mealId: String) {
        viewModel = RecipeViewModel(with: mealId, apiManager: APIManager())
        imageView = UIImageView()
        tableview = UITableView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = viewModel.recipe.name
    }
    
    func setup() {
        tableview.register(IngredientRow.self, forCellReuseIdentifier: String(describing: IngredientRow.self))
        tableview.register(InstructionRow.self, forCellReuseIdentifier: String(describing: InstructionRow.self))
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.separatorStyle = .none
        view.addSubview(tableview)
        view.embed(childView: tableview, in: view)
    }
}

/**
 Extension for tableview delegate methods
 */
extension RecipeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

/**
 Extension for tableview datasource methods
 */
extension RecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.numberOfRowsForIngredients() : viewModel.numberOfRowsForInstructions()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IngredientRow.self), for: indexPath) as? IngredientRow else  {
                fatalError("TableView was unable to return a IngredientRow")
            }
            cell.configure(with: viewModel.ingredient(for: indexPath))
            cell.clipsToBounds = true
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InstructionRow.self), for: indexPath) as? InstructionRow else  {
                fatalError("TableView was unable to return a IngredientRow")
            }
            cell.configure(with: viewModel.instruction(for: indexPath))
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Ingredients for one serving"
        case 1: return "Instructions"
        default: return "Something is WRONG"
        }
    }
}

/**
 Extension for viewmodel delegate methods
 */
extension RecipeViewController: RecipeViewModelDelegate {
    func onFetched() {
        tableview.reloadData()
        title = viewModel.recipe.name
    }
}


