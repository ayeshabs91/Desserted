//
//  MealRecipe.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation

struct Recipe: Codable, Hashable {
    let name: String
    let instructions: [String]?
    let ingredients: [Ingredient]?
    
    init(name: String, instructions: [String]?, ingredients: [Ingredient]?) {
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions        
    }
    
    init(from rawData: [String: Any]) {
        let detailResponse = rawData["meals"] as? [Any]
        guard let recipeInfo = detailResponse?[0] as? [String:Any] else {
            print("Response included no meals")
            self.name = ""
            self.ingredients = nil
            self.instructions = nil
            return
        }
        guard let name = recipeInfo["strMeal"] as? String else {
            print("There is no meal name")
            self.name = ""
            self.ingredients = nil
            self.instructions = nil
            return
        }
        
        // Name
        self.name = name
        
        // Instructions
        var instructions: [String]?
        if let instructionsString = recipeInfo["strInstructions"] as? String {
            let instructionsArray = instructionsString.split(whereSeparator: \.isNewline)
            instructions = instructionsArray.map { String($0) }
        }
        self.instructions = instructions
        
        // Ingredients
        var ingredients = [String:(name: String, measurement: String)]()
        for (key, value) in recipeInfo {
            let ingredientPrefix = "strIngredient"
            let measurementPrefix = "strMeasure"
            
            guard let value = value as? String else { continue }
            var keyString = key
            if keyString.hasPrefix(ingredientPrefix) {
                keyString = String(keyString.dropFirst(ingredientPrefix.count))
                ingredients[keyString, default: ("","")].name = value
            } else if keyString.hasPrefix(measurementPrefix) {
                keyString = String(keyString.dropFirst(measurementPrefix.count))
                ingredients[keyString, default: ("","")].measurement = value
            }
        }
        if ingredients.isEmpty || instructions == nil {
            self.ingredients = [Ingredient]()
            return
        }
        var ingredientsArray = [Ingredient]()
        for (key, value) in ingredients.values {
            ingredientsArray.append(Ingredient(name: key, measurement: value))
        }

        self.ingredients = ingredientsArray.filter({ ingredient in
            !ingredient.name.isEmpty && !ingredient.measurement.isEmpty
        })
    }    
}

struct RecipeResponse: Codable {
    let recipe: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case recipe = "meals"
    }
}

struct Ingredient: Codable, Hashable {
    let name: String
    let measurement: String
}
