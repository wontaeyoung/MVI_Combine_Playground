protocol DependencyContainerProtocol {
    func register<T: DependencyContainable>(_ instance: T) // 등록하기
    func resolve<T: DependencyContainable>() throws -> T // 꺼내기
    func unregister<T: DependencyContainable>(_ instance: T) // 삭제하기
}
