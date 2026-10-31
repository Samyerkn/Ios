//
//  ViewController.swift
//  MusicPlayer
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!

    // MARK: - State (single source of truth)

    private let tracks = TrackLibrary.tracks
    private var currentIndex = 0
    private var isPlaying = false

    /// Strong reference: the player must live as long as the screen does.
    private var player: AVAudioPlayer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAudioSession()
        configureButtonSymbols()
        loadCurrentTrack()
        render()
    }

    // MARK: - Actions

    @IBAction private func previousTapped(_ sender: UIButton) {
        goToTrack(at: (currentIndex - 1 + tracks.count) % tracks.count)
    }

    @IBAction private func playPauseTapped(_ sender: UIButton) {
        if isPlaying {
            isPlaying = false
            player?.pause()
        } else {
            if player == nil { loadCurrentTrack() }
            guard let player else {
                showError("Could not play “\(tracks[currentIndex].title)”. The audio file is missing or broken.")
                return
            }
            isPlaying = player.play()
        }
        render()
    }

    @IBAction private func nextTapped(_ sender: UIButton) {
        goToTrack(at: (currentIndex + 1) % tracks.count)
    }

    // MARK: - AVAudioPlayerDelegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard flag else { return }
        isPlaying = true
        goToTrack(at: (currentIndex + 1) % tracks.count)
    }

    // MARK: - Playback

    private func goToTrack(at index: Int) {
        guard tracks.indices.contains(index) else { return }
        currentIndex = index
        loadCurrentTrack()
        if isPlaying {
            // keep the play state: if it was playing, the new track starts playing
            isPlaying = player?.play() ?? false
        }
        render()
    }

    private func loadCurrentTrack() {
        player?.stop()
        player = nil

        let track = tracks[currentIndex]
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: track.fileExtension)
                ?? Bundle.main.url(forResource: track.fileName, withExtension: track.fileExtension, subdirectory: "Audio") else {
            print("⚠️ Audio file not found: \(track.fileName).\(track.fileExtension)")
            return
        }

        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self
            newPlayer.prepareToPlay()
            player = newPlayer
        } catch {
            print("⚠️ Could not open \(track.fileName).\(track.fileExtension): \(error.localizedDescription)")
        }
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ Audio session error: \(error.localizedDescription)")
        }
    }

    // MARK: - UI

    private func configureButtonSymbols() {
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .semibold)
        for button in [previousButton, playPauseButton, nextButton] {
            button?.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        }
        previousButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
    }

    /// Refreshes the whole screen from `currentIndex` and `isPlaying`.
    private func render() {
        let track = tracks[currentIndex]
        coverImageView.image = UIImage(named: track.coverImageName)
        titleLabel.text = track.title
        artistLabel.text = track.artist
        let symbol = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: symbol), for: .normal)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Playback error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
