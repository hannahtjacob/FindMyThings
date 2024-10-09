//
//  AddItemView.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/6/24.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var locations: [String] = [""]
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Info")) {
                    TextField("Item Name", text: $name)
                    
                    // Dynamic Location Fields
                    ForEach(locations.indices, id: \.self) { index in
                        HStack {
                            TextField("Location Level \(index + 1)", text: $locations[index])
                            if locations.count > 1 {
                                Button(action: {
                                    removeLocation(at: index)
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: addLocation) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Location Level")
                        }
                    }
                }
                
                Button("Add Item") {
                    // Filter out empty location levels
                    let filteredLocations = locations.filter { !$0.isEmpty }
                    viewModel.addItem(name: name, locations: filteredLocations)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add New Item")
        }
    }
    
    // Function to add a new location field
    private func addLocation() {
        locations.append("")
    }
    
    // Function to remove a location field
    private func removeLocation(at index: Int) {
        locations.remove(at: index)
    }
}
