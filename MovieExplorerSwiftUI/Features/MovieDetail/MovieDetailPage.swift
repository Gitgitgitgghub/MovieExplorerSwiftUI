//
//  MovieDetailPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct MovieDetailPage: View {
    
    var movieID: Int
    
    var body: some View {
        Text("\(movieID)")
    }
}

#Preview {
    MovieDetailPage(movieID: 0)
}
