import SwiftUI

struct GizmoPanel: View {
    @ObservedObject var coasterVM: CoasterViewModel
    
    var body: some View {
        // Find the specific point we are editing
        if let index = coasterVM.points.firstIndex(where: { $0.id == coasterVM.selectedPointID }) {
            VStack(alignment: .leading, spacing: 25) {
                // --- Orientation Section ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("Orientation").font(.system(size: 24, weight: .bold, design: .rounded)).foregroundStyle(.blue)
                    
                    HStack(spacing: 5) {
                        Text("q =").font(.system(.title3, design: .monospaced))
                        
                        // Binding to Quaternion components
                        MathInput(value: $coasterVM.points[index].orientation.real, label: "w")
                            .onChange(of: coasterVM.points[index].orientation.real) { old, new in
                                coasterVM.newTrackUpdateID()
                            }
                        Text("+")
                        MathInput(value: $coasterVM.points[index].orientation.imag.x, label: "i")
                            .onChange(of: coasterVM.points[index].orientation.real) { old, new in
                                coasterVM.newTrackUpdateID()
                            }
                        Text("+")
                        MathInput(value: $coasterVM.points[index].orientation.imag.y, label: "j")
                            .onChange(of: coasterVM.points[index].orientation.real) { old, new in
                                coasterVM.newTrackUpdateID()
                            }
                        Text("+")
                        MathInput(value: $coasterVM.points[index].orientation.imag.z, label: "k")
                            .onChange(of: coasterVM.points[index].orientation.real) { old, new in
                                coasterVM.newTrackUpdateID()
                            }
                    }
                }
                
                // --- Position Section ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("Position").font(.system(size: 24, weight: .bold, design: .rounded)).foregroundStyle(.blue)
                    
                    HStack(spacing: 15) {
                        MathInput(value: $coasterVM.points[index].position.x, label: "x")
                        MathInput(value: $coasterVM.points[index].position.y, label: "y")
                        MathInput(value: $coasterVM.points[index].position.z, label: "z")
                    }
                }
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10) 
        }
    }
}
