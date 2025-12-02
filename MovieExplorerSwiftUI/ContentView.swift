//
//  ContentView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/26.
//

import SwiftUI

struct ContentView: View {
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Open Detail 1") {
                    path.append("Hello")
                }
            }
            .navigationDestination(for: String.self) { value in
                Text("Detail: \(value)")
            }
        }
    }
}


#Preview {
    ContentView()
}
