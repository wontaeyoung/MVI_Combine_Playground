protocol IntentHandlerProtocol: DependencyContainable {
    associatedtype State
    associatedtype Intent
    func handle(_ intent: Intent)
}
