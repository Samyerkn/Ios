//
//  UserProfile.swift
//  ProfileScreen
//

import Foundation

struct UserProfile {
    let name: String
    let role: String
    let city: String
    let posts: Int
    let followers: Int
    let following: Int
    let about: String
    /// Name of an image in Assets.xcassets. If it does not exist, initials are shown instead.
    let avatarImageName: String
}

extension UserProfile {

    static let sample = UserProfile(
        name: "Yerkin Samal",
        role: "Student",
        city: "Almaty",
        posts: 31,
        followers: 444,
        following: 306,
        about: "I'm a fourth-year student at KBTU in Almaty. I enjoy books, films, and learning new things. I'm always looking for fresh ideas and ways to grow.",
        avatarImageName: "avatar"
    )

    /// Long text test from the assignment.
    static let longNameTest = UserProfile(
        name: "Maximilian Alexander von Habsburg",
        role: "iOS Developer",
        city: "Almaty",
        posts: 128,
        followers: 4200,
        following: 312,
        about: "Building banking apps in Swift. I like clean architecture, coffee and long walks in the mountains around Almaty.",
        avatarImageName: "avatar"
    )

    /// "AB" from "Aigerim Bekova": first letters of the first and the last word.
    var initials: String {
        let words = name.split(separator: " ")
        let letters = [words.first, words.count > 1 ? words.last : nil].compactMap { $0?.first }
        return String(letters).uppercased()
    }
}
