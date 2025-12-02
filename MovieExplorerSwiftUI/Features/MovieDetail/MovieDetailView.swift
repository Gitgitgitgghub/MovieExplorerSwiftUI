//
//  MovieDetailView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct MovieDetailView: View {
    
    var movieID: Int
    
    var body: some View {
        Text("\(movieID)")
    }
}

#Preview {
    MovieDetailView(movieID: 0)
}
