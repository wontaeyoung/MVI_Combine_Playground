import Combine
import SwiftUI
import Observation

// MARK: - 학습한 내용
/// Dependency Container의 의존성 주입 로직 해결
/// MVI 패턴
/// Combine의 스레드 지정과 sink 클로저 처리 (finish, error, receivedValue)
/// Handler.State.humans에 접근해서 업데이트 하기 -> 배열의 값 타입 객체에 접근해서 직접 프로퍼티 수정 불가 -> 기존 객체를 참고해서 만든 새 객체를 업데이트하고 기존 자리에 덮어쓰기 해야함

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
            
            repository
                .fetch()
                .delay(for: .seconds(2), scheduler: DispatchQueue.global())
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
