//
//  FavoriteLibrary.swift
//  FavoritesList
//
//  The single place where the list of favorites is defined.
//

import Foundation

enum FavoriteLibrary {

    static let items: [FavoriteItem] = [
        FavoriteItem(title: "Spider-Man", subtitle: "Marvel • 2002", imageName: "movie01", rating: 5, accentHex: "FF3B4E"),
        FavoriteItem(title: "Top Gun", subtitle: "Action • 1986", imageName: "movie02", rating: 4, accentHex: "38BDF8"),
        FavoriteItem(title: "Avengers", subtitle: "Marvel • 2012", imageName: "movie03", rating: 5, accentHex: "818CF8"),
        FavoriteItem(title: "Batman", subtitle: "DC • 1989", imageName: "movie04", rating: 4, accentHex: "FACC15"),
        FavoriteItem(title: "Iron Man", subtitle: "Marvel • 2008", imageName: "movie05", rating: 5, accentHex: "F59E0B"),
        FavoriteItem(title: "Avatar", subtitle: "Sci-Fi • 2009", imageName: "movie06", rating: 4, accentHex: "22D3EE"),
        FavoriteItem(title: "The Sopranos", subtitle: "TV Series • HBO • 1999", imageName: "movie07", rating: 5, accentHex: "F87171"),
        FavoriteItem(title: "Harry Potter", subtitle: "Fantasy • 2001", imageName: "movie08", rating: 5, accentHex: "A78BFA"),
        FavoriteItem(title: "Breaking Bad", subtitle: "TV Series • AMC • 2008", imageName: "movie09", rating: 5, accentHex: "4ADE80"),
        FavoriteItem(title: "The Boys", subtitle: "TV Series • Prime • 2019", imageName: "movie10", rating: 4, accentHex: "FB923C"),
        FavoriteItem(title: "Interstellar", subtitle: "Sci-Fi • 2014", imageName: "movie11", rating: 5, accentHex: "818CF8"),
        FavoriteItem(title: "Inception", subtitle: "Thriller • 2010", imageName: "movie12", rating: 5, accentHex: "67E8F9"),
        FavoriteItem(title: "The Lord of the Rings", subtitle: "Fantasy • 2001", imageName: "movie13", rating: 5, accentHex: "FBBF24"),
        FavoriteItem(title: "Star Wars", subtitle: "Sci-Fi • 1977", imageName: "movie14", rating: 4, accentHex: "FDE047"),
        FavoriteItem(title: "Jurassic Park", subtitle: "Adventure • 1993", imageName: "movie15", rating: 4, accentHex: "84CC16"),
        FavoriteItem(title: "Titanic", subtitle: "Drama • 1997", imageName: "movie16", rating: 4, accentHex: "38BDF8"),
        FavoriteItem(title: "Stranger Things", subtitle: "TV Series • Netflix • 2016", imageName: "movie17", rating: 4, accentHex: "EF4444"),
        FavoriteItem(title: "Game of Thrones", subtitle: "TV Series • HBO • 2011", imageName: "movie18", rating: 4, accentHex: "CBD5E1"),
        FavoriteItem(title: "Money Heist", subtitle: "TV Series • Netflix • 2017", imageName: "movie19", rating: 3, accentHex: "F43F5E"),
        FavoriteItem(title: "Squid Game", subtitle: "TV Series • Netflix • 2021", imageName: "movie20", rating: 2, accentHex: "EC4899")
    ]
}
