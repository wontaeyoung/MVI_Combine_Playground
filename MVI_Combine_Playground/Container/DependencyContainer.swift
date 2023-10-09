final class DependencyContainer: DependencyContainerProtocol {
    // MARK: - Property
    static let shared: DependencyContainer = .init()
    private var registry: [ObjectIdentifier: DependencyContainable] = [:]
    
    // MARK: - Initializer
    private init() { }
    
    // MARK: - Method
    func register<T: DependencyContainable>(_ instance: T) {
        let key: ObjectIdentifier = .init(T.self)
        
        registry.updateValue(instance, forKey: key)
    }
    
    func resolve<T: DependencyContainable>() throws -> T {
        let key: ObjectIdentifier = .init(T.self)
        
        guard let instance: T = registry[key] as? T else {
            throw DependencyContainerError.instanceNotRegistered
        }
        
        return instance
    }
    
    func unregister<T: DependencyContainable>(_ instance: T) {
        let key: ObjectIdentifier = .init(T.self)
        
        registry.removeValue(forKey: key)
    }
}
