//
//  DessertDetailView.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import SwiftUI

struct RecipeDetailView: View {
    var meal: Meal
    @StateObject private var viewModel = RecipeDetailViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let mealDetail = viewModel.mealDetail {
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(mealDetail.strMeal)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let imageUrl = URL(string: mealDetail.strMealThumb) {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(10)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(10)
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
                            .padding([.top, .bottom], 5)
                        
                        ForEach(viewModel.getIngredients(from: mealDetail), id: \.self) { ingredient in
                            Text(ingredient)
                        }
                    }
                    .padding()
                }
            } else {
                Text("Failed to load meal details.")
                    .padding()
            }
        }
        .task {
            await viewModel.fetchMealDetail(by: meal.idMeal)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
