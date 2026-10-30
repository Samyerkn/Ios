# Profile screen (Module 8 · Assignment · Variant A)

UIKit, Storyboard only. All views and constraints are set in `Main.storyboard`; no `UIStackView`. Swift code only fills in data.

- Avatar: 96 × 96 circle, centered (initials by default; add an image named `avatar` to Assets to show a photo)
- Name: up to 2 lines, centered
- Stats: 3 equal-width columns with dividers (Equal Widths constraints)
- Follow / Message: equal widths, 12 pt gap, 48 pt tall
- About: wraps with no line limit
- 16 pt side margins, everything inside the Safe Area

## Long text test
In `ViewController.swift` change `UserProfile.sample` to `UserProfile.longNameTest`.

## Screenshots

| iPhone SE (3rd gen) | iPhone 16 Pro Max |
|---|---|
| ![SE](screenshots/se.png) | ![Pro Max](screenshots/promax.png) |
