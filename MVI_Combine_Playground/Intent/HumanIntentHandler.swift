import Combine
import SwiftUI
import Observation

@Observable
final class HumanIntentHandler {
    let repository: Repository
    private var cancellables: Set<AnyCancellable> = []
    var state: State
    
    init(state: State) {
        self.repository = DependencyContainer.shared.getDependency() as HumanRepository
        self.state = state
    }
}

extension HumanIntentHandler: IntentHandlerProtocol {
    struct State {
        var humans: [Human] = []
        var isLoading: Bool = false
        var alert: AlertState = .init()
    }
    
    enum Intent {
        case addHumanButtonTapped(name: String, age: Int)
        case increaseButtonTapped(human: Human)
        case requestHumanFromFirestore
        case showErrorAlert(_ error: Error)
    }
    
    convenience init() {
        self.init(state: State())
    }
    
    func handle(_ intent: Intent) {
        switch intent {
        case let .addHumanButtonTapped(name, age):
            let newHuman: Human = .init(name: name, age: age)
            state.humans.append(newHuman)
            
        case let .increaseButtonTapped(human):
            guard let index = state.humans.firstIndex(where: { $0.id == human.id }) else {
                return
            }
            var updatedHuman: Human = human
            updatedHuman.age += 1
            state.humans[index] = updatedHuman
            
        case .requestHumanFromFirestore:
            state.isLoading = true
            
            Task {
                try await Task.sleep(for: .seconds(2))
                
                repository
                    .fetch()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        guard let self else { return }
                        
                        switch completion {
                        case .finished:
                            state.isLoading = false
                            
                        case .failure(let error):
                            state.isLoading = false
                            handle(.showErrorAlert(error))
                        }
                    } receiveValue: { [weak self] humans in
                        guard let self else { return }
                        
                        state.humans = humans
                    }
                    .store(in: &cancellables)
            }
            
        case let .showErrorAlert(error):
            defer {
                state.alert.showing = true
            }
            
            guard let error = error as? AppErrorProtocol else {
                state.alert.description = "알 수 없는 문제가 발생했어요! 다시 시도해주세요."
                return
            }
            
            state.alert.description = error.errorDescription
        }
    }
}
