import SwiftUI

/// A horizontal tab bar displayed above the terminal content,
/// styled to match native macOS tab bars.
struct HorizontalTabBarView: View {
    let tabs: [HorizontalTabItem]
    let backgroundColor: Color
    let onSelectTab: (UUID) -> Void
    let onNewTab: () -> Void
    let onRemoveTab: (UUID) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Tabs fill available space equally
                ForEach(tabs) { tab in
                    HorizontalTabItemView(
                        tab: tab,
                        canClose: tabs.count > 1,
                        onClose: { onRemoveTab(tab.id) }
                    )
                    .contentShape(Rectangle())
                    .onTapGesture { onSelectTab(tab.id) }
                }

                // "+" button at trailing edge
                Button(action: onNewTab) {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 4)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 3)
            .background(backgroundColor.opacity(0.85))

            // Bottom separator
            Divider()
                .background(Color.white.opacity(0.08))
        }
    }
}

private struct HorizontalTabItemView: View {
    let tab: HorizontalTabItem
    let canClose: Bool
    let onClose: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 0) {
            // Left: close button (or invisible placeholder to keep layout stable)
            Group {
                if isHovered && canClose {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white.opacity(0.35))
                            .frame(width: 14, height: 14)
                    }
                    .buttonStyle(.plain)
                } else {
                    Color.clear.frame(width: 14, height: 14)
                }
            }

            Spacer(minLength: 0)

            // Center: title
            Text(tab.title)
                .font(.system(size: 11))
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundColor(.white.opacity(tab.isSelected ? 0.85 : 0.4))

            Spacer(minLength: 0)

            // Right: keyboard shortcut indicator
            if tab.index <= 8 {
                Text("⌘\(tab.index)")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(tab.isSelected ? 0.35 : 0.2))
            } else {
                Color.clear.frame(width: 14, height: 14)
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 26)
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(tab.isSelected
                      ? Color.white.opacity(0.1)
                      : isHovered ? Color.white.opacity(0.04) : Color.clear)
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
