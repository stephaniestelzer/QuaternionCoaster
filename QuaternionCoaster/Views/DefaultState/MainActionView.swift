import SwiftUI

struct MainActionView: View {
    @ObservedObject var coasterVM: CoasterViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Header: The text lives "on top" of the glass
            VStack(alignment: .leading, spacing: 8) {
                Text("Quaternion Coaster")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                
                Text("What would you like to do?")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Buttons: Using system glass styles
            VStack(spacing: 12) {
                GlassButton("Add a Point", systemImage: "plus", isProminent: true) {
                    // coasterVM.addPointAtCamera()
                }
                
                GlassButton("Run Coaster", systemImage: "play.fill") {
                    // Run logic
                }
            }
        }
        .padding(24)
        .frame(width: 340)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(.white.opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)    }
}
