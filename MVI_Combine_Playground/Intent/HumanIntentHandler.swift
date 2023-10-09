import Combine
import SwiftUI

final class HumanIntentHandler: ObservableObject {
    let repository: Repository
    private var cancellables: Set<AnyCancellable> = []
    @Published var state: State
    
    init(state: State) {
        self.repository = DependencyContainer.shared.getDependency() as HumanRepository
        self.state = state
    }
}
