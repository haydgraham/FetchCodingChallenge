//
//  DessertList.swift
//  FetchCodingChallenge
//
//  Created by Samuel Hayden Graham on 7/31/24.
//

import SwiftUI

struct DessertList: View {
    let dessertNames = [
        "Apam Balik",
        "Apple & Blackberry Crumble",
        "Apple Frangipan Tart",
        "Bakewell Tart",
        "Banana Pancakes",
        "Battenberg Cake",
        "BeaverTails",
        "Blackberry Fool",
        "Bread and Butter Pudding",
        "Budino Di Ricotta",
        "Canadian Butter Tarts",
        "Carrot Cake",
        "Cashew Ghoriba Biscuits",
        "Chelsea Buns",
        "Chinon Apple Tarts",
        "Choc Chip Pecan Pie",
        "Chocolate Avocado Mousse",
        "Chocolate Caramel Crispy",
        "Chocolate Gateau",
        "Chocolate Raspberry Brownies",
        "Chocolate Souffle",
        "Christmas Cake",
        "Christmas Pudding Flapjack",
        "Christmas Pudding Trifle",
        "Classic Christmas Pudding",
        "Dundee Cake",
        "Eccles Cakes",
        "Eton Mess",
        "Honey Yogurt Cheesecake",
        "Hot Chocolate Fudge",
        "Jam Roly-Poly",
        "Key Lime Pie",
        "Krispy Kreme Donut",
        "Madeira Cake",
        "Mince Pies",
        "Nanaimo Bars",
        "New York Cheesecake",
        "Pancakes",
        "Parkin Cake",
        "Peach & Blueberry Grunt",
        "Peanut Butter Cheesecake",
        "Peanut Butter Cookies",
        "Pear Tarte Tatin",
        "Polskie Naleśniki (Polish Pancakes)",
        "Portuguese Custard Tarts",
        "Pouding Chomeur",
        "Pumpkin Pie",
        "Rock Cakes",
        "Rocky Road Fudge",
        "Rogaliki (Polish Croissant Cookies)",
        "Salted Caramel Cheesecake",
        "Seri Muka Kuih",
        "Spotted Dick",
        "Sticky Toffee Pudding",
        "Sticky Toffee Pudding Ultimate",
        "Strawberries Romanoff",
        "Strawberry Rhubarb Pie",
        "Sugar Pie",
        "Summer Pudding",
        "Tarte Tatin",
        "Timbits",
        "Treacle Tart",
        "Tunisian Orange Cake",
        "Walnut Roll Gužvara",
        "White Chocolate Creme Brulee"
    ]
    
    @State private var searchText = ""
    @State private var filteredDessertNames: [String] = []
    
    var filteredDesserts: [String] {
        guard !searchText.isEmpty else { return dessertNames }
        return dessertNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredDesserts, id: \.self) { dessert in
                NavigationLink(destination: DessertDetailView(dessertName: dessert)) {
                    Text(dessert)
                }
            }
            .navigationTitle("Dessert Recipes")
                        .onAppear {
                            filteredDessertNames = dessertNames
                        }
                        .searchable(text: $searchText, prompt: "Search Dessert")
                    }
                }

            }

struct DessertList_Previews: PreviewProvider {
    static var previews: some View {
        DessertList()
    }
}
