//
//  MovieSearch.swift
//  MovieSearch
//

import Foundation

// MARK: - Movie Search

class MovieSearch: Decodable {
    let search: [Movie]?
    let errorMessage: String?
    private let responseString: String
    private let totalResultsString: String?

    enum CodingKeys: String, CodingKey {
        case responseString = "Response"
        case search = "Search"
        case errorMessage = "Error"
        case totalResultsString = "totalResults"
    }
}

// MARK: - Helpers

extension MovieSearch {

    var response: Bool { responseString == "True" }

    var totalResults: Int? {
        guard let str = totalResultsString else {
            return nil
        }

        return Int(str)
    }

}
