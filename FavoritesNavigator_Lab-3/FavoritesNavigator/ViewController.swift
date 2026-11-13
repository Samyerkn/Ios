//
//  ViewController.swift
//  FavoritesNavigator
//
//  The list screen.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    private enum Constants {
        /// Reuse identifier of the prototype cell (Main.storyboard)
        static let cellIdentifier = "FavoriteCell"
        /// Identifier of the Show segue from the cell to the Detail screen (Main.storyboard)
        static let segueIdentifier = "showDetail"
    }

    @IBOutlet private weak var tableView: UITableView!

    private let items = FavoriteLibrary.items

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    /// Deselects the tapped row when we come back from the Detail screen.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.segueIdentifier,
              let detailViewController = segue.destination as? DetailViewController,
              let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        // Only data is passed. The Detail screen fills its own outlets.
        detailViewController.item = items[indexPath.row]
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
