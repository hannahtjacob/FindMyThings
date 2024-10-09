//
//  ViewModel.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/6/24.
//

import Foundation

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    
    init() {
        fetchItems()
    }
    
    func addItem(name: String, locations: [String]) {
        DatabaseManager.shared.insertItem(itemName: name, locations: locations)
        fetchItems() // Refresh the data
    }
    
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            DatabaseManager.shared.deleteItem(withID: item.id)
        }
        fetchItems() // Refresh the data
    }
    
    private func fetchItems() {
        items = DatabaseManager.shared.fetchItems().map { $0.item }
    }
}

