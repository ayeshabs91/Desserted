//
//  RecipeViewModel.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation

/**
 protocol for recipe view model
 */
protocol RecipeViewModelDelegate: AnyObject {
    func onFetched()
}

/**
 view model for recipe screen to show recipe of a selected meal
 */
class RecipeViewModel {
    
    private let apiManager: APIManager
    weak var delegate: RecipeViewModelDelegate?
    var recipe = Recipe(name: "", instructions: nil, ingredients: nil)
    
    // MARK:- Init
    
    init(with mealId: String, apiManager: APIManager) {
        self.apiManager = apiManager
        fetchRecipe(for: mealId)
    }
    
    // MARK:- Network calls
    
    func fetchRecipe(for mealId: String) {
        guard let url = EndPoint().urlFor(recipe: mealId) else {
            return
        }
        self.apiManager.fetch(from: url, of: Recipe.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                break
            case .success(let recipe):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.recipe = recipe
                    self.delegate?.onFetched()
                }                
            }
        }
    }
    
    // MARK:- Provide data to the view
    
    func numberOfRowsForIngredients() -> Int {
        return recipe.ingredients?.count ?? 0
    }
    
    func numberOfRowsForInstructions() -> Int {
        recipe.instructions?.count ?? 0
    }
    
    func ingredient(for indexPath: IndexPath) -> Ingredient {
        return recipe.ingredients?[indexPath.row] ?? Ingredient(name: "", measurement: "")
    }
    
    func instruction(for indexPath: IndexPath) -> String {
        return recipe.instructions?[indexPath.row] ?? ""
    }
}
