import SwiftUI

//
//  ProjectAgentView.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-31.
//


struct ProjectAgentView: View {
    @Binding var projectDescription: String
    @Binding var isAgentActive: Bool
    let onReturnToProjects: () -> Void

    @State private var aiStrength: Double = 0.5
    @State private var keyPoints: [String] = []
    @State private var showingKeyPointEditor = false

    var body: some View {
        VStack(spacing: 16) {
            // Header with return button
            HStack {
                Button(action: onReturnToProjects) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(Font.system(size: 16))
                        Text("Projects")
                            .font(Font.custom("SF Pro", size: 14, relativeTo: .body))
                    }
                    .foregroundColor(.glow)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()

                // AI Status indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(isAgentActive ? Color.green : Color.gray)
                        .frame(width: CGFloat(8), height: CGFloat(8))
                        .scaleEffect(isAgentActive ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAgentActive)

                    Text(isAgentActive ? "AI Active" : "AI Standby")
                        .font(Font.custom("SF Pro", size: 12, relativeTo: .caption))
                        .foregroundColor(.foregroundSecondary)
                }
            }

            // Project Description
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Project Description")
                        .font(Font.custom("SF Pro", size: 16, relativeTo: .headline))
                        .fontWeight(.semibold)
                        .foregroundColor(.foregroundPrimary)

                    Spacer()

                    Button(action: { isAgentActive.toggle() }) {
                        Text(isAgentActive ? "Deactivate" : "Activate")
                            .font(Font.custom("SF Pro", size: 12, relativeTo: .caption))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(isAgentActive ? Color.red.opacity(0.2 as Double) : Color.glow.opacity(0.2 as Double))
                            .cornerRadius(CGFloat(6))
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                TextEditor(text: $projectDescription)
                    .font(Font.custom("SF Pro", size: 14, relativeTo: .body))
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                    .background(Color.novaGray.opacity(0.3 as Double))
                    .cornerRadius(CGFloat(8))
                    .frame(minHeight: 100, maxHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isAgentActive ? Color.glow.opacity(0.5 as Double) : Color.separator, lineWidth: 1)
                    )
            }

            // AI Strength Slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("AI Influence")
                        .font(Font.custom("SF Pro", size: 14, relativeTo: .body))
                        .foregroundColor(.foregroundPrimary)

                    Spacer()

                    Text("\(Int(aiStrength * 100))%")
                        .font(Font.custom("SF Pro", size: 12, relativeTo: .caption))
                        .foregroundColor(.foregroundSecondary)
                }

                Slider(value: $aiStrength, in: 0...1)
                    .accentColor(.glow)
            }

            // Key Points
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Key Points")
                        .font(Font.custom("SF Pro", size: 14, relativeTo: .body))
                        .foregroundColor(.foregroundPrimary)

                    Spacer()

                    Button(action: { showingKeyPointEditor = true }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.glow)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                if keyPoints.isEmpty {
                    Text("No key points defined")
                        .font(Font.custom("SF Pro", size: 12, relativeTo: .caption))
                        .foregroundColor(.foregroundSecondary)
                        .italic()
                } else {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 6) {
                        ForEach(keyPoints, id: \.self) { point in
                            keyPointRow(point)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .sheet(isPresented: $showingKeyPointEditor) {
            KeyPointEditor(keyPoints: $keyPoints)
        }
    }

    private func keyPointRow(_ point: String) -> some View {
        HStack {
            Circle()
                .fill(Color.glow)
                .frame(width: CGFloat(6), height: CGFloat(6))

            Text(point)
                .font(Font.custom("SF Pro", size: 12, relativeTo: .caption))
                .foregroundColor(.foregroundPrimary)

            Spacer()

            Button(action: { removeKeyPoint(point) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(Font.system(size: 12))
                    .foregroundColor(.foregroundSecondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.novaGray.opacity(0.3 as Double))
        .cornerRadius(CGFloat(6))
    }

    private func removeKeyPoint(_ point: String) {
        keyPoints.removeAll { $0 == point }
    }
}

struct KeyPointEditor: View {
    @Binding var keyPoints: [String]
    @State private var newPoint = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    TextField("Enter key point...", text: $newPoint)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Add") {
                        if !newPoint.isEmpty {
                            keyPoints.append(newPoint)
                            newPoint = ""
                        }
                    }
                    .disabled(newPoint.isEmpty)
                }

                List {
                    ForEach(keyPoints, id: \.self) { point in
                        Text(point)
                    }
                    .onDelete { indices in
                        keyPoints.remove(atOffsets: indices)
                    }
                }

                Spacer()
            }
            .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
            .navigationTitle("Key Points")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ProjectAgentView(
        projectDescription: .constant("This is a SwiftUI project focused on creating an innovative memory management system..."),
        isAgentActive: .constant(true),
        onReturnToProjects: {}
    )
}
