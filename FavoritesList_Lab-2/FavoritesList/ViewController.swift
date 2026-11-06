//
//  ViewController.swift
//  FavoritesList
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    private enum Constants {
        /// Must match the reuse identifier of the prototype cell in Main.storyboard
        static let cellIdentifier = "FavoriteCell"
    }

    @IBOutlet private weak var tableView: UITableView!

    private let items = FavoriteLibrary.items

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
}
