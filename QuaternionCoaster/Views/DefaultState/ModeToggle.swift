import SwiftUI

struct ModeToggle: View {
    @ObservedObject var coasterVM: CoasterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Track Interpolation")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Picker("Interpolation Mode", selection: $coasterVM.interpolationMode) {
                ForEach(RotationMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.15), lineWidth: 0.5)
            )
            
            Text(helperText)
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding(20)
        .frame(width: 350)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.bottom, 50)
    }
    
    // Dynamic helper text to explain the modes to the user
    private var helperText: String {
        switch coasterVM.interpolationMode {
            case .quaternion:
                return "Uses SLERP for perfectly smooth 3D rotation."
            case .euler:
                return "Uses LERP on Euler angles. Watch for Gimbal Lock jitters!"
        }
    }
}
