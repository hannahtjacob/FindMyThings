//
//  ItemModel.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/6/24.
//

import Foundation

struct Item: Identifiable, Codable {
    let id: UUID
    var name: String
    var locations: [String]
}
