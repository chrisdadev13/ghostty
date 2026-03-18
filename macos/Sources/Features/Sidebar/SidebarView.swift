import SwiftUI

/// A flat list item for the sidebar, either a section header or a task row.
private enum SidebarListItem: Identifiable {
    case header(StatusGroup)
    case tab(SidebarTab)

    var id: String {
        switch self {
        case .header(let group): return "header-\(group)"
        case .tab(let tab): return tab.id.uuidString
        }
    }
}

struct SidebarView: View {
    let tabs: [SidebarTab]
    let backgroundColor: Color
    @Binding var sortMode: SidebarSortMode
    let onSelectTab: (UUID) -> Void
    let onNewTab: () -> Void
    let onRemoveTab: (UUID) -> Void

    /// A slightly adjusted shade for the sidebar background,
    /// derived from the terminal's background color.
    private var sidebarBackground: Color {
        // Slightly shift from terminal bg so the sidebar is distinguishable
        backgroundColor.opacity(0.85)
    }

    /// Flat list of items for grouped mode: headers interspersed with tabs.
    private var groupedItems: [SidebarListItem] {
        var items: [SidebarListItem] = []
        for group in StatusGroup.allCases {
            let matching = tabs.filter { StatusGroup(from: $0.status) == group }
            if !matching.isEmpty {
                items.append(.header(group))
                for tab in matching {
                    items.append(.tab(tab))
                }
            }
        }
        return items
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Tasks")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
                Button {
                    sortMode = sortMode.toggled
                } label: {
                    Image(systemName: sortMode.icon)
                        .foregroundColor(.white.opacity(0.5))
                }
                .buttonStyle(.plain)
                .help(sortMode == .recent ? "Group by status" : "Sort by recent")

                Button(action: onNewTab) {
                    Image(systemName: "plus")
                        .foregroundColor(.white.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .frame(minHeight: 32)

            Divider()
                .background(Color.white.opacity(0.1))

            // Task list
            ScrollView {
                VStack(spacing: 0) {
                    switch sortMode {
                    case .recent:
                        ForEach(tabs) { tab in
                            tabRow(tab)
                        }
                    case .status:
                        ForEach(groupedItems) { item in
                            switch item {
                            case .header(let group):
                                SidebarSectionHeader(group: group)
                            case .tab(let tab):
                                tabRow(tab)
                            }
                        }
                    }
                }
            }
        }
        .frame(width: 240)
        .background(sidebarBackground)
    }

    @ViewBuilder
    private func tabRow(_ tab: SidebarTab) -> some View {
        SidebarTabRow(
            tab: tab,
            canClose: tabs.count > 1
        ) {
            onRemoveTab(tab.id)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelectTab(tab.id)
        }
    }
}

private struct SidebarSectionHeader: View {
    let group: StatusGroup

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(group.color)
                .frame(width: 6, height: 6)
            Text(group.title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.top, 10)
        .padding(.bottom, 4)
    }
}

private struct SidebarTabRow: View {
    let tab: SidebarTab
    let canClose: Bool
    let onClose: () -> Void

    @State private var isHovered = false

    private var textColor: Color {
        .white.opacity(tab.isSelected ? 0.9 : 0.5)
    }

    private var secondaryTextColor: Color {
        .white.opacity(0.3)
    }

    var body: some View {
        HStack(spacing: 8) {
            // Status icon
            Image(systemName: tab.status.icon)
                .foregroundColor(tab.status.color)
                .font(.system(size: 10))
                .frame(width: 16)

            // Title and status
            VStack(alignment: .leading, spacing: 1) {
                Text(tab.title)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(textColor)

                Text(tab.status.text)
                    .font(.system(size: 10))
                    .foregroundColor(statusSubtitleColor)
            }

            Spacer()

            // Right side: close button on hover, or unseen dot
            if isHovered && canClose {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 9))
                        .foregroundColor(secondaryTextColor)
                }
                .buttonStyle(.plain)
            } else if tab.hasUnseen {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(tab.isSelected ? Color.white.opacity(0.1) : Color.clear)
        .onHover { hovering in
            isHovered = hovering
        }
    }

    private var statusSubtitleColor: Color {
        switch tab.status {
        case .claudeInProgress:
            return .orange.opacity(0.7)
        case .claudeIdle:
            return .green.opacity(0.7)
        case .claudeNeedsInput:
            return .blue.opacity(0.7)
        default:
            return secondaryTextColor
        }
    }
}
