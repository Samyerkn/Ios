//
//  ViewController.swift
//  ProfileScreen
//
//  Only fills the screen with data. All layout lives in Main.storyboard.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var initialsLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var postsCountLabel: UILabel!
    @IBOutlet private weak var followersCountLabel: UILabel!
    @IBOutlet private weak var followingCountLabel: UILabel!
    @IBOutlet private weak var aboutTextLabel: UILabel!

    /// Switch to `.longNameTest` to run the long text test.
    private let profile = UserProfile.sample

    override func viewDidLoad() {
        super.viewDidLoad()
        fill(with: profile)
    }

    private func fill(with profile: UserProfile) {
        nameLabel.text = profile.name
        subtitleLabel.text = "\(profile.role) · \(profile.city)"
        postsCountLabel.text = Self.shortNumber(profile.posts)
        followersCountLabel.text = Self.shortNumber(profile.followers)
        followingCountLabel.text = Self.shortNumber(profile.following)
        aboutTextLabel.text = profile.about

        if let image = UIImage(named: profile.avatarImageName) {
            avatarImageView.image = image
            initialsLabel.isHidden = true
        } else {
            avatarImageView.image = nil
            initialsLabel.text = profile.initials
            initialsLabel.isHidden = false
        }
    }

    /// 312 -> "312", 4200 -> "4.2K", 12000 -> "12K"
    private static func shortNumber(_ value: Int) -> String {
        guard value >= 1000 else { return String(value) }
        let thousands = Double(value) / 1000
        let text = String(format: "%.1f", thousands)
        return (text.hasSuffix(".0") ? String(text.dropLast(2)) : text) + "K"
    }
}
