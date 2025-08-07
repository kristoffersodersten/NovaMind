import AppKit
import SwiftUI

// MessageRowAttachments.swift
// File preview and drag/drop for MessageRow


// Placeholder typ för FileAttachment
struct FileAttachment: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
    let type: String
    let size: Int64 // Size in bytes
}

struct MessageRowAttachments: View {
    public let attachment: FileAttachment
    public let onRemove: () -> Void

    @State private var isHovered = false

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "doc")
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(attachment.name)
                    .systemFont(Font.caption)
                    .lineLimit(1)
                Text(formatFileSize(attachment.size))
                    .systemFont(Font.caption2)
                    .foregroundColor(.secondary)
            }
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
        .shadow(color: isHovered ? Color.accentColor.opacity(0.3) : .clear, radius: isHovered ? 6 : 0)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
            NSWorkspace.shared.open(attachment.url)
        }
    }

    private func formatFileSize(_ bytes: Int64) -> String {
        ByteCountFormatter().string(fromByteCount: bytes)
    }
}
