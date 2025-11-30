import SwiftUI
import RealityKit
import ARKit

// MARK: - Root view
struct CoasterAppRoot: View {
    @StateObject var coasterVM = CoasterViewModel()
    
    var body: some View {
        ARCoasterView(coasterVM: coasterVM)
            .onAppear {
                coasterVM.setupInitialPoints()
            }
    }
}

// MARK: - ARCoasterView
struct ARCoasterView: UIViewRepresentable {
    @ObservedObject var coasterVM: CoasterViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(coasterVM: coasterVM)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // 1. Run AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [] // We don't need planes for world anchors
        arView.session.run(config)

        // 2. Add a debug option to visualize the World Origin (Optional, but helpful)
//        arView.debugOptions = [.showWorldOrigin]

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // This function is called whenever coasterVM changes.
        // We delegate the logic to the coordinator to keep this clean.
        context.coordinator.syncPoints(in: uiView)
    }
}

// MARK: - Coordinator
class Coordinator: NSObject {
    var coasterVM: CoasterViewModel
    
    // Keep track of IDs we have already added to the scene
    private var addedAnchorIds: Set<UUID> = []

    init(coasterVM: CoasterViewModel) {
        self.coasterVM = coasterVM
    }

    func syncPoints(in arView: ARView) {
        for point in coasterVM.points {
            // Only add the anchor if we haven't added it yet
            if !addedAnchorIds.contains(point.id) {
                arView.scene.addAnchor(point.anchor)
                addedAnchorIds.insert(point.id)
                print("Added point: \(point.id)")
            }
        }
    }
}
