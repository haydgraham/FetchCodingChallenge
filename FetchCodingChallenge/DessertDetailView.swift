//
//  DessertDetailView.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import SwiftUI

struct DessertDetailView: View {
    var meal: Meal
    @State private var mealDetail: MealDetail?
    
    var body: some View {
        VStack {
            if let mealDetail = mealDetail {
                Text(mealDetail.strInstructions)
                    .padding()
            } else {
                Text("Loading...")
                    .padding()
            }
        }
        .task {
            await getDetailsById()
        }
        .navigationTitle(meal.strMeal)
    }
    
    func getDetailsById() async {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(meal.id)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Raw JSON data: \(String(data: data, encoding: .utf8)!)") // Debugging line to print raw JSON data
            
            if let decodedResponse = try? JSONDecoder().decode(MealDetailResponse.self, from: data) {
                mealDetail = decodedResponse.meals.first
            } else {
                print("Failed to decode response")
            }
            
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }

}

#Preview {
    DessertDetailView(meal: Meal(strMeal: "ice Cream", strMealThumb: "sdfas", idMeal: "sasdfasd"))
}
