//
//  DessertViewModel.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import Foundation
import SwiftUI
import Observation

@Observable
class RecipeListViewModel: ObservableObject {
    var meals = [Meal]()
    var isLoading = false
    var searchTerm = ""
    
    var filteredRecipes: [Meal] {
        guard !searchTerm.isEmpty else { return meals }
        return meals.filter { $0.strMeal.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    func fetchMeals() async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            print("Invalid URL")
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MealsResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.meals = decodedResponse.meals
                    self.isLoading = false
                }
            } else {
                print("Failed to decode JSON")
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
}
