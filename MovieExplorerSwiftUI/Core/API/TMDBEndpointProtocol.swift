//
//  TMDBEndpointProtocol.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import Foundation

protocol TMDBEndpointProtocol {
    
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

