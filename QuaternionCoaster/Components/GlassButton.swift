import SwiftUI

struct GlassButton: View {
    let title: String
    let icon: String?
    let isProminent: Bool
    let action: () -> Void
    
    init(_ title: String, systemImage: String? = nil, isProminent: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = systemImage
        self.isProminent = isProminent
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        // Applying the reusable Liquid Glass style
        .buttonStyle(CustomGlassButtonStyle(isProminent: isProminent))
    }
}

// Internal helper for the style
private struct CustomGlassButtonStyle: ButtonStyle {
    let isProminent: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(.white.opacity(isProminent ? 0.2 : 0.1))
            }
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
