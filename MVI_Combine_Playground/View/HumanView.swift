import SwiftUI

struct HumanView: View {
    @Bindable private var handler: HumanIntentHandler = DependencyContainer.shared.getDependency()
    @State private var nameField: String = ""
    @State private var age: Int = 0
    
    var body : some View {
        VStack {
            List(handler.state.humans) { human in
                HStack {
                    VStack(alignment: .leading) {
                        Text("이름 : \(human.name)")
                        Text("나이 : \(human.age)")
                    }
                    
                    Spacer()
                    
                    Button {
                        handler.handle(.increaseButtonTapped(human: human))
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
            TextField("이름을 입력해주세요.", text: $nameField)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Text(age.description)
                
                Stepper(value: $age, in: 0...100) {
                    Text("살")
                }
            }
            
            Button {
                handler.handle(.addHumanButtonTapped(name: nameField, age: age))
                nameField.removeAll()
                age = .zero
            } label: {
                Text("등록하기")
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .disabled(nameField.isEmpty || age == .zero)
            
            HStack {
                Button {
                    withAnimation {
                        handler.handle(.requestHumanFromFirestore)
                    }
                } label: {
                    Text("서버에 요청하기")
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                
                if handler.state.isLoading {
                    ProgressView()
                }
            }
        }
        .padding(20)
        .alert("에러!", isPresented: $handler.state.alert.showing) {
            Button {
                handler.state.alert.showing = false
            } label: {
                Text("OK")
            }
        } message: {
            Text(handler.state.alert.description)
        }
    }
}
