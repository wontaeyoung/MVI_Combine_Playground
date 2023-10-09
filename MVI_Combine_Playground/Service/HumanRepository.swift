import Combine

final class HumanRepository: Repository {
    func fetch() -> AnyPublisher<[Human], Error> {
        Future<[Int], Error> { promise in
             promise(.success([1, 2, 3]))
        }
        .map { numbers in
            return numbers.map { number in
                return Human(name: "Kaz \(number)", age: number)
            }
        }
        .eraseToAnyPublisher()
    }
}

