import Foundation
import SwiftUI
import simd

class CoasterViewModel: ObservableObject {
    @Published var points: [CoasterPoint] = []

    func setupInitialPoints() {
        print("setupInitialPoints()")
        points = [
            CoasterPoint(position: SIMD3(-0.3, 0, -0.6)),
            CoasterPoint(position: SIMD3(0, 0, -0.6)),
            CoasterPoint(position: SIMD3(0.3, 0, -0.6)),
        ]
    }
}
