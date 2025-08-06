import SwiftUI

//
//  TagCloudView.swift
//  NovaMind
//
//  Created by AI Assistant on 2025-08-02.
//


struct TagCloudView: View {
    @State private var tags = ["AI", "Machine Learning", "NLP", "SwiftUI", "Neural Networks"]
    @State private var aiGeneratedTags = ["AI", "Machine Learning"]
    @State private var showEditableCloud = true

    var body: some View {
        VStack(spacing: 30) {
            Text("TagCloud Interactive View")
                .font(Font.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.foregroundPrimary)

            // Control section
            VStack(spacing: 16) {
                Toggle("Redigerbar tagg-moln", isOn: $showEditableCloud)
                    .font(Font.headline)

                if showEditableCloud {
                    Button("Lägg till slumpmässig tagg") {
                        let newTags = ["Swift", "iOS", "macOS", "Design", "UX", "Backend", "API", "WebRTC"]
                        if let randomTag = newTags.randomElement(), !tags.contains(randomTag) {
                            withAnimation(.spring()) {
                                tags.append(randomTag)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Lägg till AI-genererad tagg") {
                        let aiTags = ["Deep Learning", "Computer Vision", "Transformers", "GPT"]
                        if let randomTag = aiTags.randomElement(), !tags.contains(randomTag) {
                            withAnimation(.spring()) {
                                tags.append(randomTag)
                                aiGeneratedTags.append(randomTag)
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
            .krilleCard()

            // Editable TagCloud with AI-generated indicators
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("AI-Enhanced TagCloud")
                        .font(Font.headline)
                        .foregroundColor(.foregroundPrimary)

                    if !aiGeneratedTags.isEmpty {
                        Label("\(aiGeneratedTags.count) AI-genererade", systemImage: "sparkles")
                            .font(Font.caption)
                            .foregroundColor(.glow)
                    }
                }

                Text("✨ AI-genererade taggar har gnista-ikon och tjockare kant")
                    .font(Font.caption)
                    .foregroundColor(.foregroundSecondary)

                TagCloudView(
                    tags: tags,
                    editable: showEditableCloud,
                    aiGenerated: aiGeneratedTags,
                    onDelete: { tag in
                        withAnimation(.spring()) {
                            tags.removeAll { $0 == tag }
                            aiGeneratedTags.removeAll { $0 == tag }
                        }
                    },
                    onTagSelected: { tag in
                        print("Vald tagg: \(tag)")
                    }
                )
            }
            .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
            .krilleCard()

            // Non-editable TagCloud
            VStack(alignment: .leading, spacing: 12) {
                Text("Icke-redigerbar TagCloud")
                    .font(Font.headline)
                    .foregroundColor(.foregroundPrimary)

                Text("Endast läsning med hover-effekter")
                    .font(Font.caption)
                    .foregroundColor(.foregroundSecondary)

                TagCloudView(
                    tags: ["Design", "UX", "UI", "Prototyping", "User Research"],
                    editable: false,
                    onTagSelected: { tag in
                        print("Klickade på: \(tag)")
                    }
                )
            }
            .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
            .krilleCard()

            // Legacy TagInfo support demo
            VStack(alignment: .leading, spacing: 12) {
                Text("Legacy TagInfo Support")
                    .font(Font.headline)
                    .foregroundColor(.foregroundPrimary)

                Text("Bakåtkompatibilitet med befintlig TagInfo struktur")
                    .font(Font.caption)
                    .foregroundColor(.foregroundSecondary)

                TagCloudView(
                    tags: [
                        TagInfo(name: "Swift", count: 12),
                        TagInfo(name: "UI", count: 8),
                        TagInfo(name: "Memory", count: 5),
                        TagInfo(name: "Canvas", count: 3),
                        TagInfo(name: "Animation", count: 7)
                    ],
                    onTagSelected: { tag in
                        print("Legacy tag selected: \(tag)")
                    }
                )
            }
            .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
            .krilleCard()

            Spacer()
        }
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    TagCloudView()
        .frame(width: CGFloat(600), height: CGFloat(800))
}
