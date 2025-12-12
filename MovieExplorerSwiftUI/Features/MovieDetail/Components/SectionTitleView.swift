//
//  SectionTitleView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/11.
//

import SwiftUI

extension MovieDetailPage {
    struct SectionTitleView: View {
        
        var text: String = "Section Title"
        
        var body: some View {
            Text(text)
                .font(.title3.weight(.bold))
                .foregroundColor(AppColor.primaryText)
        }
    }
}

#Preview {
    MovieDetailPage.SectionTitleView()
}
