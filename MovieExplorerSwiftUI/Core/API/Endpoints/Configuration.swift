//
//  Configuration.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import Foundation

struct ConfigurationDetails: TMDBEndpointProtocol {
    typealias Response = ConfigurationDetailsResponse

    var path: String { "/configuration" }
    var queryItems: [URLQueryItem] { [] }
}
