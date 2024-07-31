//
//  DessertList.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import SwiftUI

struct DessertList: View {
    @State private var meals = [Meal]()
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(meals) { meal in
                    NavigationLink(destination: DessertDetailView(meal: meal)) {
                        Text(meal.strMeal)
                    }
                }
            }
            .navigationTitle("Dessert Recipes")
            .task {
                await fetchMeals()
            }
        }
    }
    
    func fetchMeals() async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MealsResponse.self, from: data) {
                meals = decodedResponse.meals
            } else {
                print("Failed to decode JSON")
            }
            
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
}




struct DessertList_Previews: PreviewProvider {
    static var previews: some View {
        DessertList()
    }
}
