//
//  DatabaseManager.swift
//  FindMyThings
//
//  Created by Hannah Jacob on 10/8/24.
//

import SQLite
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: Connection?
    
    // Define the tables
    private let itemsTable = Table("items")
    private let locationsTable = Table("locations")
    
    // Define the columns for the items table
    private let id = Expression<UUID>("id")
    private let name = Expression<String>("name") // This is the column expression

    // Define the columns for the locations table
    private let locationID = Expression<Int64>("id")
    private let itemID = Expression<UUID>("item_id")
    private let locationLevel = Expression<String>("location_level")
    
    private init() {
        connectToDatabase()
        createTables()
    }
    
    // Connect to the SQLite database
    private func connectToDatabase() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/items.db")
            print("Database connection successful!")
        } catch {
            print("Unable to open database. Error: \(error)")
        }
    }
    
    // Create tables for items and locations
    private func createTables() {
        do {
            // Create the items table
            try db?.run(itemsTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
            })
            
            // Create the locations table
            try db?.run(locationsTable.create(ifNotExists: true) { table in
                table.column(locationID, primaryKey: .autoincrement)
                table.column(itemID)
                table.column(locationLevel)
            })
            
            print("Tables created successfully!")
        } catch {
            print("Unable to create tables. Error: \(error)")
        }
    }
    
    // Insert a new item with its associated locations
    func insertItem(itemName: String, locations: [String]) {
        let itemUUID = UUID() // Generate a UUID for the new item
        
        do {
            // Insert the item into the items table
            try db?.run(itemsTable.insert(id <- itemUUID, name <- itemName)) // Change name to itemName
            
            // Insert each location into the locations table
            for location in locations {
                try db?.run(locationsTable.insert(itemID <- itemUUID, locationLevel <- location))
            }
            
            print("Item and locations inserted successfully!")
        } catch {
            print("Error inserting item: \(error)")
        }
    }
    
    // Fetch all items and their associated locations
    func fetchItems() -> [(item: Item, locations: [String])] {
        var result: [(item: Item, locations: [String])] = []
        
        do {
            // Fetch all items from the items table
            let items = try db?.prepare(itemsTable)
            
            for itemRow in items! {
                let itemUUID = itemRow[id]
                let itemName = itemRow[name]
                
                // Fetch associated locations from the locations table
                var locations: [String] = []
                let locationQuery = locationsTable.filter(itemID == itemUUID)
                
                // Use if-let to safely unwrap the optional locationRows
                if let locationRows = try db?.prepare(locationQuery) {
                    for locationRow in locationRows {
                        locations.append(locationRow[locationLevel])
                    }
                } else {
                    print("No locations found for item: \(itemName)")
                }
                
                let item = Item(id: itemUUID, name: itemName, locations: locations)
                result.append((item, locations))
            }
            
        } catch {
            print("Error fetching items: \(error)")
        }
        
        return result
    }

    
    // Delete an item and its associated locations
    func deleteItem(withID itemUUID: UUID) {
        do {
            // Delete the item from the items table
            let item = itemsTable.filter(id == itemUUID)
            try db?.run(item.delete())
            
            // Delete associated locations from the locations table
            let locations = locationsTable.filter(itemID == itemUUID)
            try db?.run(locations.delete())
            
            print("Item and locations deleted successfully!")
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}
