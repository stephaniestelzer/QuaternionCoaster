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
        
        // 1. Add Tap Gesture
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
        
        // Save reference to ARView in coordinator for hit testing
        context.coordinator.arView = arView

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // This function is called whenever coasterVM changes.
        // We delegate the logic to the coordinator to keep this clean.
        context.coordinator.syncPoints(in: uiView)
        context.coordinator.updateSelectionVisuals()
    }
}

// MARK: - Coordinator
class Coordinator: NSObject {
    var coasterVM: CoasterViewModel
    weak var arView: ARView? // Weak reference to avoid memory leaks
    
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
    
    func updateSelectionVisuals() {
        for point in coasterVM.points {
            let isSelected = (point.id == coasterVM.selectedPointID)
            point.updateSelectionVisuals(isSelected: isSelected)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let arView = self.arView else { return }
        
        // Get 2D touch location
        let tapLocation = sender.location(in: arView)
        
        // Ask ARView: "Did I hit any entity at this point?"
        if let hitEntity = arView.entity(at: tapLocation) {
            
            // Check if the entity name matches one of our IDs
            if let uuid = UUID(uuidString: hitEntity.name) {
                print("Tapped object with ID: \(uuid)")
                
                // Update the ViewModel (Must be on main thread)
                DispatchQueue.main.async {
                    self.coasterVM.handleTap(on: uuid)
                }
            }
        }
    }
}
