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
    @State private var room = ""
    @State private var shelf = ""
    @State private var box = ""
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Info")) {
                    TextField("Item Name", text: $name)
                    
                    // Multiple levels for location
                    TextField("Room", text: $room)
                    TextField("Shelf", text: $shelf)
                    TextField("Box", text: $box)
                }
                
                Button("Add Item") {
                    // Collect all the location levels
                    let locations = [room, shelf, box].filter { !$0.isEmpty }
                    viewModel.addItem(name: name, locations: locations)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add New Item")
        }
    }
}

