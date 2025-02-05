//
//  BharathFetchRecipesTests.swift
//  BharathFetchRecipesTests
//
//  Created by Bharath Sirangi on 2/3/25.
//

import XCTest
@testable import BharathFetchRecipes

@MainActor
class BFRecipeViewModelTests: XCTestCase {
    
    let testImageURL = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
    let viewModel = BFRecipeViewModel()

    func testFetchingRecipes() async {
        await viewModel.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
        XCTAssertFalse(viewModel.recipes.isEmpty)
    }
    
    func testEmptyDataHandling() async {
        await viewModel.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
    
    func testMalformedDataHandling() async {
        await viewModel.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        XCTAssertNil(viewModel.recipes.first(where: { $0.name.isEmpty }))
    }
    
    func testLoadImageSuccess() async {
        let image = await viewModel.loadImage(from: testImageURL)
        XCTAssertNotNil(image)
    }
    
    func testImageCaching() async {
        let cache = ImageCache()
        let testImage = UIImage(systemName: "photo")!
        
        cache.set(testImageURL, testImage)
        let cachedImage = cache.get(testImageURL)
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage, testImage)
    }
}
