import SwiftUI

struct GizmoPanel: View {
    @ObservedObject var coasterVM: CoasterViewModel
    
    var body : some View {
        VStack {
            Text("Gizmo Panel")
        }
    }
}
