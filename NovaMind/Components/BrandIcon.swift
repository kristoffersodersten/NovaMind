import SwiftUI


/// Dynamisk NovaMind/Brand icon som växlar mellan light/dark och stöd för plattformsspecifika varianter.
public struct BrandIcon: View {
    public enum IconSize {
        case small
        case medium
        case large
        case custom(CGFloat)
        case monochrome // Reserverad för framtiden

        var value: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 56
            case .large: return 96
            case .custom(let customSize): return customSize
            case .monochrome: return 56 // Standardstorlek för framtida användning
            }
        }
    }

    private let size: IconSize

    public init(size: IconSize = .medium) {
        self.size = size
    }

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    public var body: some View {
        let (imageName, description) = BrandIcon.assetName(for: colorScheme)

        Image(imageName, bundle: .main)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.value, height: size.value)
            .clipShape(RoundedRectangle(cornerRadius: size.value * 0.21, style: .continuous))
            .shadow(color: .black.opacity(0.08 as Double), radius: 3, x: 0, y: 2)
            .accessibilityLabel(description)
    }

    /// Dynamisk asset selection utifrån SwiftUI ColorScheme och plattform
    public static func assetName(for colorScheme: ColorScheme) -> (String, String) {
        #if os(iOS) || os(tvOS)
        switch colorScheme {
        case .dark:
            return ("BrandIconDark", "NovaMind dark icon")
        case .light:
            return ("BrandIconLight", "NovaMind light icon")
        @unknown default:
            return ("BrandIconLight", "NovaMind icon")
        }
        #elseif os(macOS)
        switch colorScheme {
        case .dark:
            return ("BrandIconDark", "NovaMind dark icon")
        case .light:
            return ("BrandIconLight", "NovaMind light icon")
        @unknown default:
            return ("BrandIconLight", "NovaMind icon")
        }
        #elseif os(watchOS) || os(visionOS)
        return ("BrandIconMonochrome", "NovaMind icon")
        #else
        return ("BrandIconLight", "NovaMind icon")
        #endif
    }

    /// Returnerar endast bildnamnet för visning/debug
    public static func iconName(for colorScheme: ColorScheme) -> String {
        return assetName(for: colorScheme).0
    }
}

struct BrandIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 18) {
            BrandIcon(size: .small)
            BrandIcon(size: .medium)
            BrandIcon(size: .large)
        }
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
        .background(Color(.windowBackgroundColor))
        .previewLayout(.sizeThatFits)
    }
}
