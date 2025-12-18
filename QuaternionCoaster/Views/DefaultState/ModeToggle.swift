import SwiftUI

struct ModeToggle: View {
    @ObservedObject var coasterVM: CoasterViewModel
    @Binding var selection: RotationMode
    @Namespace private var pickerNamespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(RotationMode.allCases) { method in
                Text(method.rawValue)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(selection == method ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle()) // Makes the whole segment tappable
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selection = method
                        }
                    }
                    .background {
                        if selection == method {
                            // This is the sliding indicator
                            Capsule()
                                .fill(.white.opacity(0.2)) // Subtle "lift"
                                .matchedGeometryEffect(id: "selectionIndicator", in: pickerNamespace)
                        }
                    }
            }
        }
        .frame(width: 240)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(4)
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.1), lineWidth: 0.5)
        )
        
    }
    
    // Dynamic helper text to explain the modes to the user
    private var helperText: String {
        switch coasterVM.rotationMode {
            case .quaternion:
                return "Uses SLERP for perfectly smooth 3D rotation."
            case .euler:
                return "Uses LERP on Euler angles. Watch for Gimbal Lock jitters!"
        }
    }
}
