//
//  ViewModel.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/6/24.
//

import Foundation

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = [] {
        didSet {
            saveItems()
        }
    }
    
    private let itemsKey = "items_key"
    
    init() {
        loadItems()
    }
    
    func addItem(name: String, location: String) {
        let newItem = Item(id: UUID(), name: name, location: location)
        items.append(newItem)
    }
    
    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    private func loadItems() {
        if let savedData = UserDefaults.standard.data(forKey: itemsKey),
           let decodedItems = try? JSONDecoder().decode([Item].self, from: savedData) {
            items = decodedItems
        }
    }
}
