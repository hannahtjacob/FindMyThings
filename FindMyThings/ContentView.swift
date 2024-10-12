//
//  ContentView.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ItemViewModel()
    @State private var searchText: String = "" // State to hold the search query
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar to filter items by name
                HStack {
                    TextField("Search by item name", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                // List of items, filtered by searchText
                List {
                    ForEach(filteredItems) { item in
                        NavigationLink(destination: EditItemView(viewModel: viewModel, item: item)) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.locations.joined(separator: " > "))
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }
                .navigationTitle("Items")
                .navigationBarItems(trailing: NavigationLink(destination: AddItemView(viewModel: viewModel)) {
                    Text("Add")
                })
            }
        }
    }
    
    // Computed property to filter items based on the search text
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return viewModel.items
        } else {
            return viewModel.items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

#Preview {
    ContentView()
}
