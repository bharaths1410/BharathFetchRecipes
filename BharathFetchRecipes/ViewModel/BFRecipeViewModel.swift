//
//  RecipeViewModel.swift
//  BharathFetchRecipes
//
//  Created by Bharath Sirangi on 2/3/25.
//
import SwiftUI

@MainActor
class BFRecipeViewModel: ObservableObject {
    @Published var recipes: [BFRecipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let cache = BFImageCache()

    func fetchRecipes(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // Check if data is empty
            guard !data.isEmpty else {
                self.recipes = []
                self.errorMessage = "No recipes available."
                return
            }
            
            let decodedRecipes = try JSONDecoder().decode(BFRecipeModel.self, from: data)
            self.recipes = decodedRecipes.recipes // Update recipes list
        } catch let decodingError as DecodingError {
            self.errorMessage = "Failed to decode recipes: \(decodingError.localizedDescription)"
            self.recipes = []
        } catch {
            self.errorMessage = "Failed to fetch recipes: \(error.localizedDescription)"
            self.recipes = []
        }
    }
    
    func loadImage(from urlString: String?) async -> UIImage? {
        guard let urlString = urlString, let url = URL(string: urlString) else { return nil }
        
        if let cachedImage = cache.get(urlString) {
            return cachedImage
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                cache.set(urlString, image)
                return image
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        return nil
    }
}
