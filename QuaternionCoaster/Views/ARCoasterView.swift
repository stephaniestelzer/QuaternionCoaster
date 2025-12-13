import SwiftUI
import RealityKit
import ARKit

// MARK: - Entry Point
/* App Entry Point:
 Create a Coaster View Model (@StateObject annotation makes it persist for life of app)
*/
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
/*
 Creates ARView for the SwiftUI App
 Required SwiftUI Functions: makeUIView, updateUIView
 Create a Coordinator because app will have AR Interactions
*/
struct ARCoasterView: UIViewRepresentable {
    @ObservedObject var coasterVM: CoasterViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = []
        arView.session.run(config)
        
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
        context.coordinator.arView = arView

        return arView
    }
    
    /**
        - Called by SwiftUI whenever the view's state or bindings change
        - Update the AR scene coordinator based on how the user has interacted with the UI
     */
    func updateUIView(_ uiView: ARView, context: Context) {
        // TODO: Handle specific user interactions (i.e. only call "updateSelectionVisuals" when a user taps a specific point)
        context.coordinator.syncPoints(in: uiView)
        context.coordinator.updateSelectionVisuals()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coasterVM: coasterVM)
    }
}

// MARK: - Coordinator
/*
 Object that handles AR interactions.
 Updates the CoasterViewModel when a user interacts with the 3D scene (i.e. changes the rotation of one of the points).
*/
class Coordinator: NSObject {
    var coasterVM: CoasterViewModel
    weak var arView: ARView?
    private var addedAnchorIds: Set<UUID> = []

    init(coasterVM: CoasterViewModel) {
        self.coasterVM = coasterVM
    }

    /**
     - TRIGGER: Called by SwiftUI whenever the CoasterViewModel changes.
     - PURPOSE: Update the AR Scene with new points when they are created (always called on initialization)
     */
    func syncPoints(in arView: ARView) {
        for point in coasterVM.points {
            if !addedAnchorIds.contains(point.id) {
                arView.scene.addAnchor(point.anchor)
                addedAnchorIds.insert(point.id)
                print("Added point: \(point.id)")
            }
        }
    }
    
    /**
     - TRIGGER: Called by SwiftUI whenever the CoasterViewModel changes.
     - PURPOSE: Adjust rendered color of the selected point. CoasterViewModel's selected point was updated by 'handleTap'
     */
    func updateSelectionVisuals() {
        for point in coasterVM.points {
            let isSelected = (point.id == coasterVM.selectedPointID)
            point.updateSelectionVisuals(isSelected: isSelected)
        }
    }
    
    /**
     - TRIGGER: Called when a user taps on the screen
     - PURPOSE: Update the CoasterViewModel when a user taps a point on the screen
     */
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let arView = self.arView else { return }
        let tapLocation = sender.location(in: arView)
        
        if let hitEntity = arView.entity(at: tapLocation) {
            if let uuid = UUID(uuidString: hitEntity.name) {
                DispatchQueue.main.async {
                    self.coasterVM.handleTap(on: uuid)
                }
            }
        }
    }
}
