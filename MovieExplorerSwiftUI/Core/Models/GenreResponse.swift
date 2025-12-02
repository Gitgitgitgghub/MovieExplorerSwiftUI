//
//  GenreResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//


import Foundation

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}
