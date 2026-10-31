# Kazakh Music Player (Lab: Music Player — UIStackView & Auto Layout)

Single-screen music player in UIKit with Kazakh kuy and songs: cover, title, artist and Previous / Play-Pause / Next controls. Audio is played with `AVAudioPlayer`.

## Features
- Layout fully in `Main.storyboard`: vertical root `UIStackView` (cover 1:1, labels stack, controls stack), pinned to the Safe Area with 20 pt margins and vertically centered
- `Track` struct and `TrackLibrary` (10 tracks)
- Play/Pause toggles `play.fill` / `pause.fill`
- Next/Previous keep the play state and wrap around
- Next track starts automatically when the current one finishes
- Missing or broken audio files do not crash the app (print + alert)

## Audio
Audio files are in `MusicPlayer/Audio/` (`track01.mp3` … `track10.mp3`). Use royalty-free recordings only.

## Screenshots

| iPhone SE (3rd gen) | iPhone 16 Pro Max |
|---|---|
| ![SE](screenshots/se.png) | ![Pro Max](screenshots/promax.png) |

Screen recording: `screenshots/demo.mov`
