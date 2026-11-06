//
//  FavoriteCell.swift
//  FavoritesList
//
//  Only outlets and a method that fills the cell. No layout code.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var glowView: UIView!
    @IBOutlet private weak var accentBarView: UIView!
    /// 5 star image views, ordered left to right
    @IBOutlet private var starImageViews: [UIImageView]!

    /// Fully resets the cell from one item (cells are reused while scrolling).
    func configure(with item: FavoriteItem) {
        let accent = UIColor(hex: item.accentHex)
        posterImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        subtitleLabel.textColor = accent
        glowView.backgroundColor = accent.withAlphaComponent(0.28)
        accentBarView.backgroundColor = accent

        let rating = min(max(item.rating, 0), 5)
        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: index < rating ? "star.fill" : "star")
        }
    }
}
