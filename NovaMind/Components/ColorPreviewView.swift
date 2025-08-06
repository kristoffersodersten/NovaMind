import SwiftUI

// MARK: - Color Preview View
// Interactive color palette and theme preview component

struct ColorPreviewView: View {
    @ObservedObject var themeManager: ThemeManager
    @State private var selectedColorSet: ColorSet = .primary
    @State private var previewMode: PreviewMode = .palette
    @State private var showColorDetails: Bool = false
    @State private var hoveredColorInfo: ColorInfo?

    var body: some View {
        VStack(spacing: 0) {
            headerView
            content
            if showColorDetails {
                ColorDetailsPanel(hoveredColorInfo: $hoveredColorInfo, showColorDetails: $showColorDetails)
            }
        }
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .novaBlack.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    // MARK: - Header View

    private var headerView: some View {
        HStack {
            Text("Color Preview")
                .font(.headline)
                .foregroundColor(.foregroundPrimary)

            Spacer()

            Picker("Color Set", selection: $selectedColorSet) {
                ForEach(ColorSet.allCases, id: \.self) { colorSet in
                    Text(colorSet.displayName).tag(colorSet)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 200)

            Picker("Mode", selection: $previewMode) {
                ForEach(PreviewMode.allCases, id: \.self) { mode in
                    Image(systemName: mode.iconName).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 120)

            Button(action: { showColorDetails.toggle() }) {
                Image(systemName: showColorDetails ? "info.circle.fill" : "info.circle")
                    .foregroundColor(showColorDetails ? .glow : .foregroundSecondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundPrimary.opacity(0.8))
        .overlay(
            Rectangle().frame(height: 1).foregroundColor(.separator),
            alignment: .bottom
        )
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        Group {
            switch previewMode {
            case .palette:
                ColorPaletteView(
                    selectedColorSet: $selectedColorSet,
                    hoveredColorInfo: $hoveredColorInfo
                )
            case .gradient:
                GradientPreviewView()
            case .components:
                ComponentPreviewView()
            case .accessibility:
                AccessibilityPreviewView()
            }
        }
        .padding(16)
    }
}

// MARK: - Preview

#if DEBUG
struct ColorPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPreviewView(themeManager: ThemeManager())
            .frame(width: 600, height: 500)
            .background(Color.backgroundPrimary)
    }
}
#endif
