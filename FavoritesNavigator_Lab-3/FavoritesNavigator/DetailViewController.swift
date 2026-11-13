//
//  DetailViewController.swift
//  FavoritesNavigator
//
//  The detail screen. It fills its own outlets from `item`.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var pillView: UIView!
    @IBOutlet private weak var ratingValueLabel: UILabel!
    @IBOutlet private weak var glowView: UIView!
    /// Round glow behind the cover
    @IBOutlet private weak var haloView: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    /// 5 star image views, ordered left to right
    @IBOutlet private var starImageViews: [UIImageView]!

    /// Set by the list in `prepare(for:sender:)`.
    var item: FavoriteItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item else { return }

        let accent = UIColor(hex: item.accentHex)

        navigationItem.title = item.title
        posterImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description

        subtitleLabel.textColor = accent
        pillView.backgroundColor = accent.withAlphaComponent(0.2)
        glowView.backgroundColor = accent.withAlphaComponent(0.25)
        haloView.backgroundColor = accent.withAlphaComponent(0.28)

        let rating = min(max(item.rating, 0), 5)
        ratingValueLabel.text = "\(rating) / 5"
        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: index < rating ? "star.fill" : "star")
        }
    }
}
