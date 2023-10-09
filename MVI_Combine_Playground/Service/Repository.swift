import Combine

protocol Repository: DependencyContainable {
    func fetch() -> AnyPublisher<[Human], Error>
}
