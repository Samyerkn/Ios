# Мои книги / My Books (Lab: Favorites Navigator)

**Author:** _your name_
**Theme:** favorite books

A UIKit app built with a Storyboard only. The list of 20 favorite books lives in a `UINavigationController` with a large "Мои книги" title. Each row shows a cover and a title; tapping it pushes a Detail screen (Show segue) with a large cover, title, author and year, star rating (SF Symbols) and a description.

- `FavoriteItem` struct, items stored in `FavoriteLibrary`
- Segue identifier `showDetail`, data passed in `prepare(for:sender:)`
- Tapped row is deselected when returning to the list
- Custom AppIcon and LaunchScreen
- Dark neon design: glass cards, glowing shapes, per-book accent colors

## Screenshots

| List | Detail | Launch Screen | App Icon |
|---|---|---|---|
| ![List](screenshots/list.png) | ![Detail](screenshots/detail.png) | ![Launch](screenshots/launch.png) | ![Icon](screenshots/icon.png) |
