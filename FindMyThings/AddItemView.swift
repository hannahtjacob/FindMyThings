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
    @State private var location = ""
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Info")) {
                    TextField("Item Name", text: $name)
                    TextField("Location", text: $location)
                }
                
                Button("Add Item") {
                    viewModel.addItem(name: name, location: location)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add New Item")
        }
    }
}
