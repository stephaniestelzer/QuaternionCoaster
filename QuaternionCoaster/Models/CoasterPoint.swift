import SwiftUI
import RealityKit
import simd

class CoasterPoint {
    let id = UUID()
    let entity: ModelEntity
    let anchor: AnchorEntity

    init(position: SIMD3<Float>) {
        // Anchor at desired world position
        self.anchor = AnchorEntity(world: position)

        // Sphere to represent the point
        self.entity = ModelEntity(
            mesh: .generateSphere(radius: 0.03),
            materials: [SimpleMaterial(color: .red, isMetallic: false)]
        )

        // XYZ gizmos
        let size: Float = 0.05
        let red = ModelEntity(mesh: .generateBox(size: [size, 0.005, 0.005]),
                              materials: [SimpleMaterial(color: .red, isMetallic: false)])
        red.position = [size/2,0,0]

        let green = ModelEntity(mesh: .generateBox(size: [0.005, size, 0.005]),
                                materials: [SimpleMaterial(color: .green, isMetallic: false)])
        green.position = [0,size/2,0]

        let blue = ModelEntity(mesh: .generateBox(size: [0.005, 0.005, size]),
                               materials: [SimpleMaterial(color: .blue, isMetallic: false)])
        blue.position = [0,0,size/2]

        entity.addChild(red)
        entity.addChild(green)
        entity.addChild(blue)

        // Attach entity to anchor
        anchor.addChild(entity)
    }
}
