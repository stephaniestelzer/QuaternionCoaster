import Foundation
import simd

class CoasterViewModel: ObservableObject {
    @Published var points: [CoasterPoint] = []
    @Published var selectedPointID: UUID? = nil
    
    init() {
        setupInitialPoints()
    }

    func setupInitialPoints() {
        points = [
            CoasterPoint(position: SIMD3(-0.3, 0, -0.6)),
            CoasterPoint(position: SIMD3(0, 0, -0.6)),
            CoasterPoint(position: SIMD3(0.3, 0, -0.6)),
        ]
    }
    
    func handleTap(on pointID: UUID) {
        if selectedPointID == pointID {
            selectedPointID = nil
        } else {
            selectedPointID = pointID
        }
    }
}
