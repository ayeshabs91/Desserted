//
//  Meals.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation

// MARK: - Meals
struct Meals: Codable {
    let meals: [Meal]
}

// MARK: - Meal
struct Meal: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

