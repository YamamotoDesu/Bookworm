# Bookworm

### [Creating a custom component with @Binding](https://www.hackingwithswift.com/books/ios-swiftui/creating-a-custom-component-with-binding)
### With @State property

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

The text view doesn’t reflect that change....

### [With @Binding property](https://github.com/YamamotoDesu/Bookworm/commit/e9d324b476c2a5392576215b2d0b5273b4d2ce4c)

<img width="300" alt="スクリーンショット 2023-03-27 15 15 55" src="https://user-images.githubusercontent.com/47273077/227859482-d82c338f-7448-48d5-ac3f-c4ee28052dd6.gif">

PushButton.swift
```swift
struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
```

ContentView.swift
```swift
struct ContentView: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton(title: "Rember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
 ```

This is the power of @Binding: as far as the button is concerned it’s just toggling a Boolean – it has no idea that something else is monitoring that Boolean and acting upon changes.
