import Combine

final class HumanRepository: Repository {
    enum ExceptedFetchResult {
        case success
        case fail
    }
    
    func fetch() -> AnyPublisher<[Human], Error> {
        let testResult: ExceptedFetchResult = .success
        
        return Future<[Int], Error> { promise in
            switch testResult {
            case .success:
                promise(.success([1, 2, 3]))
                
            case .fail:
                promise(.failure(RepositoryError.requestFailed))
            }
        }
        .map { numbers in
            return numbers.map { number in
                return Human(name: "Kaz \(number)", age: number)
            }
        }
        .eraseToAnyPublisher()
    }
}

