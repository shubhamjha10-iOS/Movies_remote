//
//  Poster.swift
//  MovieSearch
//

import Foundation

// MARK: - Poster

class Poster: Codable {
    let imdbId: String
    let imageData: Data

    init(imdbId: String, imageData: Data) {
        self.imdbId = imdbId
        self.imageData = imageData
    }
}
