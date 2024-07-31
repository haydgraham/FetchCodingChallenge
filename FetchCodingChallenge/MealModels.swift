//
//  MealModels.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import Foundation

struct Meal: Codable, Identifiable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    var id: String { idMeal }
}

struct MealsResponse: Codable {
    let meals: [Meal]
}
