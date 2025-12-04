//
//  BannerCarousel.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/4.
//

import SwiftUI

/// 輕量級橫向 Carousel，會把目前卡片置中並保留上一張與下一張的邊緣。
/// 由呼叫端提供 `cardWidth` / `cardHeight`，讓元件能精準計算置中偏移與滑動門檻。
/// - Parameters:
///   - Item: 每一個卡片對應的資料型別（需符合 `Identifiable`）。
///   - Content: 外部提供的卡片內容。
/// - Important: 卡片的實際寬、高以初始化時傳入的數值為準。

struct BannerCarousel<Item: Identifiable, Content: View>: View {
    
    @Binding var items: [Item]
    @ViewBuilder
    var content: (Item) -> Content
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    private let spacing: CGFloat
    private let cardWidth: CGFloat
    private let cardHeight: CGFloat
    private let swipeThresholdRatio: CGFloat
    
    init(
        items: Binding<[Item]>,
        spacing: CGFloat,
        cardWidth: CGFloat,
        cardHeight: CGFloat,
        swipeThresholdRatio: CGFloat,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        _items = items
        self.spacing = spacing
        self.cardWidth = cardWidth
        self.cardHeight = cardHeight
        self.swipeThresholdRatio = swipeThresholdRatio
        self.content = content
    }
    
    init(
        items: [Item],
        spacing: CGFloat,
        cardWidth: CGFloat,
        cardHeight: CGFloat,
        swipeThresholdRatio: CGFloat,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.init(items: .constant(items), spacing: spacing, cardWidth: cardWidth, cardHeight: cardHeight, swipeThresholdRatio: swipeThresholdRatio, content: content)
    }
        
    
    var body: some View {
        GeometryReader { proxy in
            // 以容器寬度換算出讓「中間卡片」剛好置中的基準偏移
            let baseOffset = proxy.size.width / 2 - (cardWidth + spacing + cardWidth / 2)
            
            LazyHStack(spacing: spacing) {
                ForEach(getDisplayItems(), id: \.id) { item in
                    content(item)
                        .frame(width: cardWidth, height: cardHeight)
                }
            }
            .frame(width: proxy.size.width, alignment: .leading)
            .offset(x: baseOffset + dragOffset)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        guard !items.isEmpty else {
                            dragOffset = 0
                            return
                        }
                        // 拖曳超過一定比例才換卡片，避免輕微晃動就觸發
                        let threshold = cardWidth * swipeThresholdRatio
                        var newIndex = currentIndex
                        if value.translation.width < -threshold {
                            newIndex = currentIndex + 1 < items.count ? currentIndex + 1 : 0
                        } else if value.translation.width > threshold {
                            newIndex = currentIndex - 1 >= 0 ? currentIndex - 1 : items.count - 1
                        }
                        withAnimation(.easeOut(duration: 0.2)) {
                            currentIndex = newIndex
                            dragOffset = 0
                        }
                    }
            )
        }
        .frame(height: cardHeight)
    }
    
    private func getDisplayItems() -> [Item] {
        guard !items.isEmpty else { return [] }
        let previousIndex = currentIndex - 1 < 0 ? items.count - 1 : currentIndex - 1
        let nextIndex = currentIndex + 1 < items.count ? currentIndex + 1 : 0
        return [items[previousIndex], items[currentIndex], items[nextIndex]]
    }
}

#Preview {
    BannerCarousel(
        items: MovieResponse.mock?.results ?? [],
        spacing: 16,
        cardWidth: 300,
        cardHeight: 450,
        swipeThresholdRatio: 0.25
    ) { item in
        AsyncImage(url: item.posterURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150 * 2, height: 150 * 3)
                    .clipped()
            }
        }
    }
}

#Preview("可調整卡片數") {
    BannerCarouselPreviewContainer()
}

private let previewMovies = MovieResponse.mock?.results ?? []

private struct BannerCarouselPreviewContainer: View {
    private let allMovies = previewMovies
    @State private var visibleMovies: [Movie]
    @State private var movieCount: Double
    
    init() {
        let initialCount = max(1, min(4, previewMovies.count))
        _visibleMovies = State(initialValue: Array(previewMovies.prefix(initialCount)))
        _movieCount = State(initialValue: Double(initialCount))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            BannerCarousel(
                items: $visibleMovies,
                spacing: 16,
                cardWidth: 280,
                cardHeight: 420,
                swipeThresholdRatio: 0.25
            ) { item in
                AsyncImage(url: item.posterURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    } else if phase.error != nil {
                        Color.red
                    } else {
                        ProgressView()
                    }
                }
            }
            
            Slider(
                value: $movieCount,
                in: 1...Double(max(allMovies.count, 1)),
                step: 1
            ) {
                Text("卡片數量")
            }
            .onChange(of: movieCount) { newValue in
                guard !allMovies.isEmpty else { return }
                let count = min(Int(newValue), allMovies.count)
                visibleMovies = Array(allMovies.prefix(count))
            }
            
            Text("目前卡片數量：\(Int(movieCount))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
