//
//  EditItemView.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/8/24.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ItemViewModel
    @State var item: Item
    @State var newLocation: String = ""
    
    var body: some View {
        Form {
            // Section to edit the item name
            Section(header: Text("Item Name")) {
                TextField("Item Name", text: $item.name)
            }
            
            // Section to edit the locations
            Section(header: Text("Locations")) {
                // List of editable locations with delete functionality
                List {
                    ForEach($item.locations.indices, id: \.self) { index in
                        TextField("Location", text: $item.locations[index])
                    }
                    .onDelete(perform: removeLocation) // Enables swipe to delete
                }
                
                // Input field to add a new location
                HStack {
                    TextField("New Location", text: $newLocation)
                    Button(action: {
                        addLocation()
                    }) {
                        Text("Add")
                    }
                }
            }
        }
        .navigationBarTitle("Edit Item", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            saveChanges()
            presentationMode.wrappedValue.dismiss() // Dismiss view after saving
        })
    }
    
    // Function to add a new location
    private func addLocation() {
        if !newLocation.isEmpty {
            item.locations.append(newLocation)
            newLocation = ""
        }
    }
    
    // Function to remove a location level
    private func removeLocation(at offsets: IndexSet) {
        item.locations.remove(atOffsets: offsets)
    }
    
    // Function to save changes to the database
    private func saveChanges() {
        viewModel.updateItem(item: item)
    }
}
