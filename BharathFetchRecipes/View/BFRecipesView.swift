//
//  ContentView.swift
//  BharathFetchRecipes
//
//  Created by Bharath Sirangi on 2/3/25.
//

import SwiftUI

struct BFRecipesView: View {
    @StateObject private var viewModel = BFRecipeViewModel()
    private let recipeURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView("Fetching recipes...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.recipes.isEmpty {
                    Text("No recipes available. Please try again later.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.recipes) { recipe in
                        BFRecipeRow(recipe: recipe, viewModel: viewModel)
                    }
                }

            }
            .navigationTitle("Recipes")
            .toolbar {
                Button("Refresh") {
                    Task { await viewModel.fetchRecipes(from: recipeURL) }
                }
            }
            .task {
                await viewModel.fetchRecipes(from: recipeURL)
            }
        }
    }
}

struct BFRecipeRow: View {
    let recipe: BFRecipe
    @ObservedObject var viewModel: BFRecipeViewModel
    @State private var image: UIImage? = nil
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                
            } else if let imageUrl = recipe.image {
                ProgressView()
                    .frame(width: 80, height: 80)
                    .onAppear {
                        Task { image = await viewModel.loadImage(from: imageUrl) }
                    }
            } else {
                Image(systemName: "photo") // Placeholder image when actual image not loaded
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    BFRecipesView()
}
