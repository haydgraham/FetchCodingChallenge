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
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(mealDetail.strMeal)
                            .font(.title)
                            .padding(.bottom)
                        
                        if let imageUrl = URL(string: mealDetail.strMealThumb) {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 200)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 100)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        Text("Instructions")
                            .font(.headline)
                            .padding(.top)
                        
                        Text(mealDetail.strInstructions)
                            .padding(.top, 5)
                        Text("Ingredients")
                            .font(.headline)
                            .padding(.top)
                        
                        ForEach(getIngredients(from: mealDetail), id: \.self) { ingredient in
                            Text(ingredient)
                        }
                        
                    }
                    .padding()
                }
            } else {
                Text("Loading...")
                    .padding()
            }
        }
        .task {
            await getDetailsById()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    DessertDetailView(meal: Meal(strMeal: "ice Cream", strMealThumb: "sdfas", idMeal: "sasdfasd"))
}
