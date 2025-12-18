import SwiftUI
import RealityKit
import simd

struct CoasterPoint {
    let id = UUID()
    var position: SIMD3<Float> // Store the raw data here
    var orientation: simd_quatf = simd_quatf(real: 1.0, imag: SIMD3<Float>(0, 0, 0)) // Identity quaternion
    var eulerAngles: SIMD3<Float> = .zero
    
    init(position: SIMD3<Float>) {
        self.position = position
    }
}
