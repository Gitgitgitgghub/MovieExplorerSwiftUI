//
//  SettingPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/03.
//

import SwiftUI

struct SettingPage: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var notificationsEnabled = true
    @State private var autoplayTrailers = true
    @State private var cellularStreaming = false
    @State private var downloadQuality: DownloadQuality = .high
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                profileCard
                appearanceSection
                preferencesSection
                streamingSection
                aboutSection
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
        .appBackground()
    }
}

private extension SettingPage {
    
    var profileCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(AppColor.accent)
                    .overlay(
                        Circle()
                            .stroke(AppColor.cardStroke, lineWidth: 1)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text("Brant Chen")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(AppColor.primaryText)
                    Text("brant@example.com")
                        .font(.subheadline)
                        .foregroundColor(AppColor.secondaryText)
                }
                Spacer()
                Button(action: {}) {
                    Text("管理帳號")
                        .font(.footnote.weight(.bold))
                        .foregroundColor(AppColor.accent)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            Capsule()
                                .fill(AppColor.badgeBackground)
                        )
                }
            }
            
            Divider()
                .background(AppColor.cardStroke)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("會員等級")
                        .font(.caption)
                        .foregroundColor(AppColor.secondaryText)
                    Text("Cinephile+")
                        .font(.headline)
                        .foregroundColor(AppColor.primaryText)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("收藏片單")
                        .font(.caption)
                        .foregroundColor(AppColor.secondaryText)
                    Text("128 部")
                        .font(.headline)
                        .foregroundColor(AppColor.primaryText)
                }
            }
        }
        .padding(20)
        .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: AppColor.shadow, radius: 12, x: 0, y: 6)
    }
    
    var appearanceSection: some View {
        SettingSection(title: "外觀模式") {
            VStack(alignment: .leading, spacing: 12) {
                Text("選擇主題")
                    .font(.subheadline)
                    .foregroundColor(AppColor.secondaryText)
                Picker("外觀模式", selection: $coordinator.theme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.title).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
                Text(coordinator.theme.description)
                    .font(.caption)
                    .foregroundColor(AppColor.tertiaryText)
            }
        }
    }
    
    var preferencesSection: some View {
        SettingSection(title: "偏好設定") {
            Toggle(isOn: $notificationsEnabled) {
                SettingRow(
                    icon: "bell.fill",
                    title: "推播通知",
                    subtitle: "掌握最新上映、片單更新"
                )
            }
            .tint(AppColor.accent)
            
            Toggle(isOn: $autoplayTrailers) {
                SettingRow(
                    icon: "play.rectangle.fill",
                    title: "自動播放預告",
                    subtitle: "在海報上停留時自動播放"
                )
            }
            .tint(AppColor.accent)
            
            Picker(selection: $downloadQuality) {
                ForEach(DownloadQuality.allCases) { option in
                    Text(option.title)
                        .tag(option)
                }
            } label: {
                SettingRow(
                    icon: "arrow.down.circle.fill",
                    title: "下載品質",
                    subtitle: downloadQuality.description
                )
            }
            .pickerStyle(.menu)
        }
    }
    
    var streamingSection: some View {
        SettingSection(title: "串流與網路") {
            Toggle(isOn: $cellularStreaming) {
                SettingRow(
                    icon: "antenna.radiowaves.left.and.right",
                    title: "允許行動網路串流",
                    subtitle: "可能增加數據使用量"
                )
            }
            .tint(AppColor.accent)
            
            Button(action: {}) {
                SettingRow(
                    icon: "icloud.and.arrow.down",
                    title: "清理暫存",
                    subtitle: "釋放儲存空間"
                )
            }
            .buttonStyle(.plain)
            
            Button(action: {}) {
                SettingRow(
                    icon: "arrow.2.squarepath",
                    title: "同步片單",
                    subtitle: "立即刷新跨裝置片單"
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    var aboutSection: some View {
        SettingSection(title: "關於 MovieExplorer") {
            Button(action: {}) {
                SettingRow(
                    icon: "sparkles",
                    title: "版本 1.0",
                    subtitle: "最新功能與更新"
                )
            }
            .buttonStyle(.plain)
            
            Button(action: {}) {
                SettingRow(
                    icon: "shield.lefthalf.fill",
                    title: "隱私政策",
                    subtitle: "瞭解我們如何保護您的資料"
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    struct SettingSection<Content: View>: View {
        let title: String
        private let content: () -> Content
        
        init(title: String, @ViewBuilder content: @escaping () -> Content) {
            self.title = title
            self.content = content
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppColor.primaryText)
                VStack(alignment: .leading, spacing: 12) {
                    content()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(AppColor.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppColor.cardStroke, lineWidth: 1)
                )
                .shadow(color: AppColor.shadow.opacity(0.7), radius: 10, x: 0, y: 4)
            }
        }
    }
    
    struct SettingRow: View {
        let icon: String
        let title: String
        let subtitle: String
        
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3.weight(.semibold))
                    .frame(width: 36, height: 36)
                    .foregroundColor(AppColor.accent)
                    .background(AppColor.badgeBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.semibold))
                        .foregroundColor(AppColor.primaryText)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(AppColor.secondaryText)
                }
                Spacer()
            }
        }
    }
}

private enum DownloadQuality: String, CaseIterable, Identifiable {
    case auto
    case high
    case medium
    case low
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .auto: return "自動"
        case .high: return "高"
        case .medium: return "中"
        case .low: return "低"
        }
    }
    
    var description: String {
        switch self {
        case .auto: return "依網路狀況自動調整"
        case .high: return "最佳畫質，需求較大容量"
        case .medium: return "平衡畫質與容量"
        case .low: return "最省容量，適合行動下載"
        }
    }
}

#Preview {
    NavigationStack {
        SettingPage()
    }
    .environmentObject(AppCoordinator())
}
