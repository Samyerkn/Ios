//
//  Track.swift
//  MusicPlayer
//

import Foundation

struct Track {
    let title: String
    let artist: String
    /// File name without extension, e.g. "track01"
    let fileName: String
    let coverImageName: String
    /// "mp3" by default; pass "m4a" for .m4a files
    var fileExtension: String = "mp3"
}
