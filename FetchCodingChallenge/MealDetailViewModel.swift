//
//  DessertDetailViewModel.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import Foundation
import SwiftUI

class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetail?
    @Published var isLoading = false
    
    func fetchMealDetail(by id: String) async {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            print("Invalid URL")
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Raw JSON data: \(String(data: data, encoding: .utf8)!)") // Debugging line to print raw JSON data
            
            if let decodedResponse = try? JSONDecoder().decode(MealDetailResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.mealDetail = decodedResponse.meals.first
                    self.isLoading = false
                }
            } else {
                print("Failed to decode response")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
            
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func getIngredients(from mealDetail: MealDetail) -> [String] {
        var ingredients: [String] = []
        
        let ingredientProperties = Mirror(reflecting: mealDetail).children.filter { $0.label?.starts(with: "strIngredient") ?? false }
        let measureProperties = Mirror(reflecting: mealDetail).children.filter { $0.label?.starts(with: "strMeasure") ?? false }
        
        for (ingredient, measure) in zip(ingredientProperties, measureProperties) {
            if let ingredientName = ingredient.value as? String, !ingredientName.isEmpty, let measureValue = measure.value as? String, !measureValue.isEmpty {
                ingredients.append("\(measureValue) \(ingredientName)")
            }
        }
        
        return ingredients
    }
}
