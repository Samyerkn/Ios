//
//  FavoriteCell.swift
//  FavoritesNavigator
//
//  Only outlets and a method that fills the cell. No layout code.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var glowView: UIView!
    @IBOutlet private weak var accentBarView: UIView!
    @IBOutlet private weak var chevronImageView: UIImageView!

    /// The list shows only the image and the title; the rest is decoration in the item's color.
    func configure(with item: FavoriteItem) {
        let accent = UIColor(hex: item.accentHex)
        posterImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        glowView.backgroundColor = accent.withAlphaComponent(0.28)
        accentBarView.backgroundColor = accent
        chevronImageView.tintColor = accent
    }
}
