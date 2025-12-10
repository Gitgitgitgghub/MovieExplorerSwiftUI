//
//  MovieDetailPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct MovieDetailPage: View {

    @StateObject private var viewModel: MovieDetailViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    init(movieID: Int, viewModel: MovieDetailViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? MovieDetailViewModel(movieID: movieID))
    }

    var body: some View {
        ScrollView {
            if let detail = viewModel.detail {
                VStack(spacing: 16) {
                    heroSection(detail: detail)
                    statCards(detail: detail)
                    overviewSection(detail: detail)
                    genresSection(detail: detail)
                    castSection
                }
                .padding(.bottom, 28)
            }
        }
        .scrollIndicators(.hidden)
        .overlay { loadingUI }
        .animation(.easeInOut(duration: 0.25), value: viewModel.loadingState)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(viewModel.detail?.title ?? "電影詳情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let detail = viewModel.detail {
                    Menu {
                        if let homepage = detail.homepage, let url = URL(string: homepage) {
                            Link(destination: url) {
                                Label("官方網站", systemImage: "link")
                            }
                        }
                        Button {
                            // 預留收藏或提醒功能
                        } label: {
                            Label("加入片單", systemImage: "bookmark.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColor.primaryText)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .appBackground()
        .task { await viewModel.load() }
    }

    // MARK: - Loading / Error
    @ViewBuilder
    private var loadingUI: some View {
        switch viewModel.loadingState {
        case .loading:
            CinematicLoadingView(
                title: "正在載入電影細節",
                subtitle: "同步劇情、卡司與官方資訊"
            )
            .padding(.horizontal, 32)
            .transition(.opacity)
        case .failed(let message):
            CinematicErrorView(
                title: "載入失敗",
                message: message,
                retryTitle: "重新整理",
                onRetry: { Task { await viewModel.load() } }
            )
            .padding(.horizontal, 24)
            .transition(.opacity)
        default:
            EmptyView()
        }
    }

    // MARK: - Sections
    private func heroSection(detail: MovieDetailResponse) -> some View {
        PosterCard(url: detail.backdropURL ?? detail.posterURL)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 16)
        .shadow(color: AppColor.shadow.opacity(0.35), radius: 16, x: 0, y: 12)
    }

    private func statCards(detail: MovieDetailResponse) -> some View {
        Grid {
            GridRow {
                statTile(title: "評分", value: String(format: "%.1f", detail.voteAverage), icon: "star.fill")
                statTile(title: "人氣", value: String(format: "%.0f", detail.popularity), icon: "flame.fill")
                statTile(title: "票數", value: "\(detail.voteCount)", icon: "person.3.fill")
            }
            GridRow {
                badge(text: detail.yearText.isEmpty ? "年份未定" : detail.yearText, icon: "calendar")
                if let status = detail.status, !status.isEmpty {
                    badge(text: status, icon: "sparkles.tv")
                }
                if let runtime = detail.runtime {
                    badge(text: "\(runtime) 分鐘", icon: "clock")
                }
            }
        }
        .padding(.horizontal)
    }

    private func genresSection(detail: MovieDetailResponse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("類型")
            if detail.genres.isEmpty {
                Text("暫無類型資訊")
                    .font(.subheadline)
                    .foregroundColor(AppColor.secondaryText)
            } else {
                ChipFlow(horizontalSpacing: 8, verticalSpacing: 8) {
                    ForEach(detail.genres, id: \.id) { genre in
                        Text(genre.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(AppColor.primaryText)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    colors: [AppColor.overlayStart.opacity(0.35), AppColor.overlayEnd.opacity(0.35)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                in: Capsule()
                            )
                            .overlay(
                                Capsule()
                                    .stroke(AppColor.cardStroke.opacity(0.8), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func overviewSection(detail: MovieDetailResponse) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(detail.title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(AppColor.primaryText)

            if let tagline = detail.tagline, !tagline.isEmpty {
                Text(tagline)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(AppColor.secondaryText)
            }
            sectionTitle("劇情簡介")
            Text(detail.overview.isEmpty ? "暫無劇情簡介" : detail.overview)
                .font(.body)
                .foregroundColor(AppColor.secondaryText)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal)
    }

    private var castSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("主要卡司")
            if let casts = viewModel.credits?.cast, !casts.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(casts) { cast in
                            CastCard(cast: cast)
                                .onTapGesture {
                                    coordinator.push(.actorDetail(id: cast.id))
                                }
                        }
                    }
                }
            } else {
                Text("暫無演員資訊")
                    .font(.subheadline)
                    .foregroundColor(AppColor.secondaryText)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.title3.weight(.bold))
            .foregroundColor(AppColor.primaryText)
    }

    private func badge(text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.subheadline.weight(.semibold))
            .foregroundColor(AppColor.mutedText)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .background(
                LinearGradient(
                    colors: [AppColor.overlayStart.opacity(0.35), AppColor.overlayEnd.opacity(0.35)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: Capsule()
            )
            .overlay(
                Capsule()
                    .stroke(AppColor.cardStroke.opacity(0.8), lineWidth: 1)
            )
    }

    private func statTile(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.bold))
                .foregroundColor(AppColor.mutedText)
            Text(value)
                .font(.title2.weight(.heavy))
                .foregroundColor(AppColor.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            LinearGradient(
                colors: [AppColor.overlayStart.opacity(0.35), AppColor.overlayEnd.opacity(0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColor.cardStroke.opacity(0.8), lineWidth: 1)
        )
    }
}

// MARK: - Cast Card
private struct CastCard: View {
    let cast: Cast

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            PosterCard(url: cast.profileURL)
            .frame(width: 110, height: 140)
            .background(placeholder)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppColor.cardStroke, lineWidth: 1)
            )

            VStack(spacing: 4) {
                Text(cast.name)
                    .font(.subheadline.weight(.bold))
                    .minimumScaleFactor(0.8)
                    .foregroundColor(AppColor.primaryText)
                    .lineLimit(1)
                Text(cast.displayCharacter.isEmpty ? "演員" : cast.displayCharacter)
                    .font(.caption)
                    .foregroundColor(AppColor.secondaryText)
                    .lineLimit(1)
            }
            .padding(.horizontal, 2)
            .frame(width: 120)
        }
    }

    private var placeholder: some View {
        LinearGradient(
            colors: [Color(.systemGray5), Color(.systemGray4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            Image(systemName: "person.crop.rectangle")
                .font(.title2.weight(.bold))
                .foregroundColor(AppColor.secondaryText)
        )
    }
}

// MARK: - Chip Flow Layout (iOS 16+ Layout)
private struct ChipFlow: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var width: CGFloat = 0
        var height: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if width + size.width > maxWidth {
                height += rowHeight + verticalSpacing
                width = 0
                rowHeight = 0
            }
            width += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(
            width: maxWidth.isFinite ? maxWidth : width,
            height: height + rowHeight
        )
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + verticalSpacing
                rowHeight = 0
            }
            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(width: size.width, height: size.height)
            )
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailPage(
            movieID: 1084242,
            viewModel: MovieDetailViewModel(
                movieID: 1084242,
                service: FakeTMDBService()
            )
        )
        .preferredColorScheme(.dark)
    }
}
