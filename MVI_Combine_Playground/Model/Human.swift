import Foundation

struct Human: Identifiable {
    let id: UUID
    let name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.id = UUID()
        self.name = name
        self.age = age
    }
}
