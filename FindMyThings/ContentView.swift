//
//  ContentView.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ItemViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
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



#Preview {
    ContentView()
}
