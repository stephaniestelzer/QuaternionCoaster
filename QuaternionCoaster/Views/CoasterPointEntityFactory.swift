import RealityKit
import simd

struct CoasterPointEntityFactory {
    
    // Constants for size
    static let radius: Float = 0.03
    static let gizmoSize: Float = 0.05
    
    // Material Definitions
    static let defaultMaterial = SimpleMaterial(color: .red, isMetallic: false)
    static let selectedMaterial = SimpleMaterial(color: .yellow, isMetallic: true)
    
    static let redMaterial = SimpleMaterial(color: .red, isMetallic: false)
    static let greenMaterial = SimpleMaterial(color: .green, isMetallic: false)
    static let blueMaterial = SimpleMaterial(color: .blue, isMetallic: false)

    // Creates and assembles the ModelEntity hierarchy for a Coaster Point.
    static func createCoasterModel() -> ModelEntity {
        
        // Create the main sphere entity
        let entity = ModelEntity(
            mesh: .generateSphere(radius: Self.radius),
            materials: [Self.defaultMaterial]
        )
        entity.generateCollisionShapes(recursive: true)
        
        // Create the XYZ Gizmos
        let redAxis = ModelEntity(
            mesh: .generateBox(size: [Self.gizmoSize, 0.005, 0.005]),
            materials: [Self.redMaterial]
        )
        redAxis.position = [Self.gizmoSize / 2, 0, 0]
        
        let greenAxis = ModelEntity(
            mesh: .generateBox(size: [0.005, Self.gizmoSize, 0.005]),
            materials: [Self.greenMaterial]
        )
        greenAxis.position = [0, Self.gizmoSize / 2, 0]
        
        let blueAxis = ModelEntity(
            mesh: .generateBox(size: [0.005, 0.005, Self.gizmoSize]),
            materials: [Self.blueMaterial]
        )
        blueAxis.position = [0, 0, Self.gizmoSize / 2]
        
        entity.addChild(redAxis)
        entity.addChild(greenAxis)
        entity.addChild(blueAxis)
        
        return entity
    }
}
