//
//  ContentView.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ItemViewModel()
    @State private var showingAddItemView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("Location: \(item.location)")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: viewModel.deleteItem)
            }
            .navigationTitle("Items to Find")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddItemView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddItemView) {
                AddItemView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
