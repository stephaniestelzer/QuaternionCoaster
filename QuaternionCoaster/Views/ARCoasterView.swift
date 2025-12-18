import SwiftUI
import RealityKit
import ARKit

// MARK: - Entry Point
/* App Entry Point:
 Create a Coaster View Model (@StateObject annotation makes it persist for life of app)
*/
// CoasterAppRoot.swift
struct CoasterAppRoot: View {
    @StateObject var coasterVM = CoasterViewModel()
    
    var body: some View {
        ZStack {
            // AR View
            ARCoasterView(coasterVM: coasterVM)
                .onAppear {
                    coasterVM.setupInitialPoints()
                }
                .ignoresSafeArea()
            
            // Resting State UI (Visible when no point is selected)
            if coasterVM.selectedPointID == nil {
                Group {
                    // Top Right: Simple Toggle
                    ModeToggle(coasterVM: coasterVM)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.top, 60)
                        .padding(.trailing, 20)
                    
                    // Bottom Center: Action Sheet
                    MainActionView(coasterVM: coasterVM)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 40)
                }
                .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.9)), removal: .opacity))
            }
            
            // Selection State UI
            if let _ = coasterVM.selectedPointID {
                GizmoPanel(coasterVM: coasterVM)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: coasterVM.selectedPointID)
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
        if coasterVM.trackUpdateID != context.coordinator.lastTrackUpdateID {
            print("Running 'updateTrackPoints'")
            context.coordinator.updateTrackPoints(in: uiView)
            
            // Update the coordinator's state so it doesn't run repeatedly.
            context.coordinator.lastTrackUpdateID = coasterVM.trackUpdateID
        }
        context.coordinator.updateSelectionVisuals()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coasterVM: coasterVM, lastRunSyncPoints: coasterVM.trackUpdateID)
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
    // private var addedAnchorIds: Set<UUID> = []
    private var trackAnchors: [UUID: AnchorEntity] = [:]
    
    // Selected Logic
    var lastTrackUpdateID: UUID

    init(coasterVM: CoasterViewModel, lastRunSyncPoints: UUID) {
        self.coasterVM = coasterVM
        self.lastTrackUpdateID = lastRunSyncPoints
    }

    /**
     - TRIGGER: When the ViewModel's 'trackUpdateID' value changes, the view's 'updateUIView' calls this function
     - PURPOSE: Update the AR Scene with anchor / model entities for the ModelView's 'points' property. Always called on initialization.
     */
    func updateTrackPoints(in arView: ARView) {
        for point in coasterVM.points {
            if trackAnchors[point.id] == nil {
                let newAnchor = createARPoint(point)
                arView.scene.addAnchor(newAnchor)
                trackAnchors[point.id] = newAnchor
            }
        }
    }
    
    /**
        Creates anchor and model entites for each of the CoasterPoint's in CoasterViewModel. AKA: Renders the points to the AR Scene
     */
    private func createARPoint(_ point: CoasterPoint) -> AnchorEntity {
        let anchor = AnchorEntity(world: point.position)
        anchor.setOrientation(point.orientation, relativeTo: nil)
        
        // Use the factory to create the model (visual) entity for the point in the scene
        let pointModelEntity = CoasterPointEntityFactory.createCoasterModel()
        pointModelEntity.name = point.id.uuidString
        
        // Make the model a child of the anchor
        anchor.addChild(pointModelEntity)
        
        return anchor
    }
    
    /**
     - TRIGGER: Called by SwiftUI whenever the CoasterViewModel changes.
     - PURPOSE: Adjust rendered color of the selected point. CoasterViewModel's selected point was updated by 'handleTap'
     */
    func updateSelectionVisuals() {
        for point in coasterVM.points {
            // Get Anchor Entity of selected point
            guard let anchor = trackAnchors[point.id] else {
                continue
            }

            // Find the ModelEntity child by its UUID name
            guard let entity = anchor.findEntity(named: point.id.uuidString) as? ModelEntity else {
                print("Error: Could not find ModelEntity child for Anchor \(point.id)")
                continue
            }
            
            let isSelected = (point.id == coasterVM.selectedPointID)
            let newMaterial = isSelected ?
                CoasterPointEntityFactory.selectedMaterial :
                CoasterPointEntityFactory.defaultMaterial
            entity.model?.materials = [newMaterial]

            // Toggle Gizmo Visibility (The gizmo axes are children of this ModelEntity)
            let gizmoIsVisible = isSelected
            entity.children.forEach { child in
                child.isEnabled = gizmoIsVisible
            }
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
