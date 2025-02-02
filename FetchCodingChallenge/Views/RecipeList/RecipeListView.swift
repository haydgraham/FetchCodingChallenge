//
//  DessertList.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
   
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ForEach(viewModel.filteredRecipes) { meal in
                        NavigationLink(destination: RecipeDetailView(meal: meal)) {
                            HStack {
                                if let imageUrl = URL(string: meal.strMealThumb) {
                                    AsyncImage(url: imageUrl) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image.resizable()
                                                .scaledToFit()
                                                .frame(maxHeight: 50)
                                                .clipShape(.circle)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxHeight: 30)
                                                .clipShape(.circle)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                                Text(meal.strMeal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .searchable(text: $viewModel.searchTerm, prompt: "Search Recipe")
            .task {
                await viewModel.fetchMeals()
            }
        }
    }
}

struct DessertList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
