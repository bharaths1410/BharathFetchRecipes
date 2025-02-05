//
//  Recipe.swift
//  BharathFetchRecipes
//
//  Created by Bharath Sirangi on 2/3/25.
//

import SwiftUI

struct BFRecipeModel: Codable {
    let recipes: [BFRecipe]
}

struct BFRecipe: Codable, Identifiable {
    let id: String
    let name: String
    let image: String?
    let cuisine: String
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case image = "photo_url_small"
        case cuisine
    }
}
