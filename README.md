# Bookworm

## With @State property

<img width="300" alt="スクリーンショット 2023-03-27 15 15 55" src="https://user-images.githubusercontent.com/47273077/227856494-6955c50d-ac36-4a8e-8c16-a223b35cebaf.gif">

ContentView.swift
```swift
struct ContentView: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton(title: "Rember Me", isOn: rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}
```

PushButton.swift
```swift
struct PushButton: View {
    let title: String
    @State var isOn: Bool
    
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}
```

