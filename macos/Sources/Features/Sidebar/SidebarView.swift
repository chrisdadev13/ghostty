import SwiftUI

struct SidebarView: View {
    let tabs: [SidebarTab]
    let backgroundColor: Color
    let onSelectTab: (UUID) -> Void
    let onNewTab: () -> Void
    let onRemoveTab: (UUID) -> Void

    /// A slightly adjusted shade for the sidebar background,
    /// derived from the terminal's background color.
    private var sidebarBackground: Color {
        // Slightly shift from terminal bg so the sidebar is distinguishable
        backgroundColor.opacity(0.85)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Tasks")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
                Button(action: onNewTab) {
                    Image(systemName: "plus")
                        .foregroundColor(.white.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()
                .background(Color.white.opacity(0.1))

            // Task list
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(tabs) { tab in
                        SidebarTabRow(
                            tab: tab,
                            canClose: tabs.count > 1,
                            backgroundColor: backgroundColor
                        ) {
                            onRemoveTab(tab.id)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onSelectTab(tab.id)
                        }
                    }
                }
            }
        }
        .frame(width: 200)
        .background(sidebarBackground)
    }
}

private struct SidebarTabRow: View {
    let tab: SidebarTab
    let canClose: Bool
    let backgroundColor: Color
    let onClose: () -> Void

    @State private var isHovered = false

    /// Text color that contrasts with the terminal background
    private var textColor: Color {
        .white.opacity(tab.isSelected ? 0.9 : 0.5)
    }

    private var secondaryTextColor: Color {
        .white.opacity(0.3)
    }

    var body: some View {
        HStack(spacing: 8) {
            // Status icon
            Image(systemName: statusIcon)
                .foregroundColor(tab.hasBell ? .yellow : secondaryTextColor)
                .font(.system(size: 10))
                .frame(width: 16)

            // Title and subtitle
            VStack(alignment: .leading, spacing: 1) {
                Text(tab.title)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(textColor)

                Text("Running")
                    .font(.system(size: 10))
                    .foregroundColor(secondaryTextColor)
            }

            Spacer()

            // Right side: close button on hover, or tab number
            if isHovered && canClose {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 9))
                        .foregroundColor(secondaryTextColor)
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 4) {
                    if tab.isSplit {
                        Image(systemName: "rectangle.split.2x1")
                            .font(.system(size: 9))
                            .foregroundColor(secondaryTextColor)
                    }
                    Text("\(tab.index)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(secondaryTextColor)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(tab.isSelected ? Color.white.opacity(0.1) : Color.clear)
        .onHover { hovering in
            isHovered = hovering
        }
    }

    private var statusIcon: String {
        if tab.hasBell {
            return "bell.fill"
        }
        return "circle.fill"
    }
}
