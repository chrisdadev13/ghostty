import Foundation

/// Data model representing a single task entry in the sidebar.
/// Each task is an independent terminal session managed by the sidebar.
struct SidebarTab: Identifiable {
    let id: UUID
    let index: Int
    let title: String
    let isSelected: Bool
    let hasBell: Bool
    let isSplit: Bool
    let isZoomed: Bool
}
