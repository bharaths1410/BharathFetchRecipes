//
//  BFImageCache.swift
//  BharathFetchRecipes
//
//  Created by Bharath Sirangi on 2/3/25.
//

import SwiftUI

class BFImageCache {
    private var cache = NSCache<NSString, UIImage>()
    
    func get(_ urlString: String) -> UIImage? {
        return cache.object(forKey: urlString as NSString)
    }
    
    func set(_ urlString: String, _ image: UIImage) {
        cache.setObject(image, forKey: urlString as NSString)
    }
}
