# Favorites List (Lab: UITableView & Custom Cells)

UIKit app with a `UITableView` and a custom cell. Theme: favorite movies and TV series (20 items), dark neon design with glass cards and glowing shapes.

- `FavoriteItem` struct, items stored in `FavoriteLibrary`
- `FavoriteCell` (own file): only `@IBOutlet`s and `configure(with:)`
- Prototype cell designed in `Main.storyboard` with nested `UIStackView`s: image (fixed 68 × 68), title, subtitle, 5-star rating (SF Symbols `star.fill` / `star`)
- Table view fills the Safe Area; cell height follows its content
- No layout code in Swift

## Screenshots

| iPhone SE (3rd gen) | iPhone 16 Pro Max |
|---|---|
| ![SE](screenshots/se.png) | ![Pro Max](screenshots/promax.png) |

Screen recording: `screenshots/scroll.mov`
