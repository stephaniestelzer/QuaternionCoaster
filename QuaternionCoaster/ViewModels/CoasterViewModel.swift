import Foundation
import simd

class CoasterViewModel: ObservableObject {
    /**
        Published Variables. These are watched for changes by ARCoasterView
        - points:
        - selectedPointID:
     */
    @Published var points: [CoasterPoint] = []
    @Published var selectedPointID: UUID? = nil
    
    /**
        Selected Logic Published Variables. Updated to signal to the coordinator in the view to run certain functions
        - trackUpdateID: when this is updated, the 'updateTrackPoints' function will execute in the View
     */
    @Published var trackUpdateID = UUID()
    
    init() {

    }

    func setupInitialPoints() {
        addPoint(position: SIMD3(-0.3, 0, -0.6))
        addPoint(position: SIMD3(0, 0, -0.6))
        addPoint(position: SIMD3(0.3, 0, -0.6))
    }
    
    func addPoint(position: SIMD3<Float>) {
        let newPoint = CoasterPoint(position: position)
        self.points.append(newPoint)
        
        // Update the trackUpdateID variable to signal the change to the ARView
        self.trackUpdateID = UUID()
    }
    
    func handleTap(on pointID: UUID) {
        if selectedPointID == pointID {
            selectedPointID = nil
        } else {
            selectedPointID = pointID
        }
    }
}
