import SwiftUI

struct GeneralThreadsView: View {
    let threads: [ChatThread]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                // Section header
                HStack {
                    Text("Allmänna Trådar")
                        .systemFont(Font.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.foregroundSecondary)
                        .textCase(.uppercase)

                    Spacer()

                    Text("\(threads.count)")
                        .systemFont(Font.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.secondary.opacity(0.2 as Double))
                        .cornerRadius(CGFloat(8))
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)

                ForEach(threads, id: \.id) { thread in
                    ThreadRow(thread: thread)
                }

                // Tom tillstånd
                if threads.isEmpty {
                    EmptyStateView(
                        title: "Inga trådar hittades",
                        systemImage: "message.badge.questionmark"
                    )
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 4)
        }
    }
}
