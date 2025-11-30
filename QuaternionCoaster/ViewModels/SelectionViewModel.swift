import SwiftUI

class SelectionViewModel: ObservableObject {
    @Published var selectedPoint: CoasterPoint?

    func select(point: CoasterPoint) {
        selectedPoint = point
    }
}
