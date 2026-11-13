//
//  FavoriteItem.swift
//  FavoritesNavigator
//

import Foundation

struct FavoriteItem {
    let title: String
    let subtitle: String
    /// Name of an image in Assets.xcassets
    let imageName: String
    /// 0...5
    let rating: Int
    /// Neon accent color of the item, e.g. "FF3B4E"
    let accentHex: String
    let description: String
}
