//
//  DessertDetailView.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import SwiftUI

struct DessertDetailView: View {
    var meal: Meal
    var body: some View {
        Text("\(meal.strMeal)")
    }
}

#Preview {
    DessertDetailView(meal: Meal(strMeal: "ice Cream", strMealThumb: "sdfas", idMeal: "sasdfasd"))
}
