struct AlertState {
    var title: String
    var description: String
    var showing: Bool
    
    init() {
        self.title = ""
        self.description = ""
        self.showing = false
    }
}
