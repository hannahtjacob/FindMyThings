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
                            TextField("Location Level \(index + 1)", text: Binding(
                                get: { locations[safe: index] ?? "" },
                                set: { newValue in
                                    if index < locations.count {
                                        locations[index] = newValue
                                    }
                                }
                            ))
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
            .onChange(of: locations) { oldValue, newValue in
                // Trigger UI refresh when locations change, if necessary
                print("Locations changed from \(oldValue) to \(newValue)")
            }
        }
    }
    
    // Function to add a new location field
    private func addLocation() {
        locations.append("")
    }
    
    // Function to remove a location field
    private func removeLocation(at index: Int) {
        if locations.count > 1 {
            locations.remove(at: index)
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
