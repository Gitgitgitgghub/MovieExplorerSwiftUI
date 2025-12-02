//
//  Mockable.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/29.
//

import Foundation

protocol Mockable where Self: Decodable {
    static var mockJson: String { get }
}

extension Mockable {
    static var mock: Self? {
        let data = Data(mockJson.utf8)
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print("Error decoding mock data: \(error)")
        }
        return nil
    }
}

