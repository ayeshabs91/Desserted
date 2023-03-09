//
//  MealsViewModel.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation
import UIKit

/**
 view model for Home screen to show meals of category Dessert
 */
class MealsViewModel {
    
    var allMeals = [Meal]()
    var apiManager: APIManager
    
    // MARK:- Init
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    // MARK:- Network calls
    
    func fetchMeals(in category: String, completion: @escaping (APIError?) -> ()) {
        guard let url = EndPoint().urlFor(category: category) else {
            completion(.invalidRequest)
            return
        }
        self.apiManager.fetch(from: url, of: Meals.self) { [weak self] result in

            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(error)
                
            case .success(let meals):
                guard let self = self else { return }
                self.allMeals = meals.meals.sorted { $0.strMeal.lowercased() < $1.strMeal.lowercased() }
                completion(nil)
            }
        }
    }
    
    // MARK:- Provide data to the view
    
    func mealForIndex(indexPath: IndexPath) -> Meal {
        allMeals[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        allMeals.count
    }
}
