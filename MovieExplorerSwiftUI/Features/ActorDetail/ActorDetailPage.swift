//
//  ActorDetailPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct ActorDetailPage: View {
    
    var actorID: Int
    
    var body: some View {
        Text(String(actorID))
    }
}

#Preview {
    ActorDetailPage(actorID: 0)
}
