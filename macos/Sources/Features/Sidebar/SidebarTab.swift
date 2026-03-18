import Foundation
import SwiftUI

/// Status of a sidebar task, derived from Claude Code hooks.
enum TaskStatus: Equatable {
    case idle
    case running
    case claudeInProgress
    case claudeIdle
    case claudeNeedsInput

    var text: String {
        switch self {
        case .idle: return "Idle"
        case .running: return "Running"
        case .claudeInProgress: return "In Progress"
        case .claudeIdle: return "Done"
        case .claudeNeedsInput: return "Needs Input"
        }
    }

    var icon: String {
        switch self {
        case .claudeInProgress: return "hourglass"
        case .claudeIdle: return "checkmark.circle.fill"
        case .claudeNeedsInput: return "bell.fill"
        default: return "circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .claudeInProgress: return .orange
        case .claudeIdle: return .green
        case .claudeNeedsInput: return .blue
        default: return .white.opacity(0.3)
        }
    }
}

/// How tasks are displayed in the sidebar.
enum SidebarSortMode: Hashable {
    case recent
    case status

    var icon: String {
        switch self {
        case .recent: return "clock"
        case .status: return "line.3.horizontal.decrease"
        }
    }

    var toggled: SidebarSortMode {
        switch self {
        case .recent: return .status
        case .status: return .recent
        }
    }
}

/// Logical grouping of task statuses for the grouped sidebar view.
enum StatusGroup: CaseIterable, Hashable {
    case needsInput
    case draft
    case running
    case done

    var title: String {
        switch self {
        case .needsInput: return "Needs Input"
        case .draft: return "Draft"
        case .running: return "Running"
        case .done: return "Done"
        }
    }

    var color: Color {
        switch self {
        case .needsInput: return .blue
        case .draft: return .white.opacity(0.3)
        case .running: return .orange
        case .done: return .green
        }
    }

    init(from status: TaskStatus) {
        switch status {
        case .claudeInProgress, .running:
            self = .running
        case .claudeNeedsInput:
            self = .needsInput
        case .claudeIdle:
            self = .done
        case .idle:
            self = .draft
        }
    }
}

/// Data model representing a single task entry in the sidebar.
/// Each task is an independent terminal session managed by the sidebar.
struct SidebarTab: Identifiable {
    let id: UUID
    let index: Int
    let title: String
    let isSelected: Bool
    let hasUnseen: Bool
    let isSplit: Bool
    let isZoomed: Bool
    let status: TaskStatus
}

/// Data model representing a single horizontal tab within a sidebar task.
struct HorizontalTabItem: Identifiable {
    let id: UUID
    let title: String
    let isSelected: Bool
    let index: Int
}
