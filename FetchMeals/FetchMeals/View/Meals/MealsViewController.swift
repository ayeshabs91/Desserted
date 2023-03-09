//
//  MealsViewController.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation
import UIKit

/**
 Home screen to display list of desserts
 */
class MealsViewController: UIViewController {
    
    private let viewModel: MealsViewModel
    private let tableview: UITableView
    
    init() {
        viewModel = MealsViewModel(apiManager: APIManager())
        tableview = UITableView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "What do you want to eat today?"
        navigationItem.backButtonDisplayMode = .minimal

        setupView()
        setupData()
    }
    
    func setupView() {
        tableview.register(MealsCellView.self, forCellReuseIdentifier: String(describing: MealsViewController.self))
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.separatorStyle = .singleLine
        tableview.separatorColor = .blue
        view.addSubview(tableview)
        view.embed(childView: tableview, in: view)
    }
    
    func setupData() {
        viewModel.fetchMeals(in: "Dessert") { apiError in
            DispatchQueue.main.async {
                if let error = apiError {
                    let alert = UIAlertController(title: "Oops", message: error.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.tableview.reloadData()
                }
            }
        }
    }
}

/**
 Extension for tableview Delegate methods
 */
extension MealsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mealAtIndex = viewModel.mealForIndex(indexPath: indexPath)
        let recipeViewController = RecipeViewController(for: mealAtIndex.idMeal)
        self.navigationController?.pushViewController(recipeViewController, animated: true)
    }    
}

/**
 Extension for tableview datasource methods
 */
extension MealsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MealsViewController.self), for: indexPath) as? MealsCellView else  {
            fatalError("TableView was unable to return a MealsCell")
        }
        cell.configure(with: viewModel.mealForIndex(indexPath: indexPath))
        return cell
    }
}
