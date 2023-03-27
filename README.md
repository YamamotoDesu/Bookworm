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


## [Accepting multi-line text input with TextEditor](https://www.hackingwithswift.com/books/ios-swiftui/accepting-multi-line-text-input-with-texteditor)

<img width="300" alt="スクリーンショット 2023-03-27 15 44 48" src="https://user-images.githubusercontent.com/47273077/227861387-29d3fdb6-7123-468e-afa8-9436626f9e9c.png">

ContentView.swift
```swift
struct ContentView: View {
    @AppStorage("notes") private var notes = ""
    
    var body: some View {
        NavigationView {
            TextEditor(text: $notes)
                .navigationTitle("Notes")
                .padding()
        }
    }
}
```

For longer pieces of text you should switch over to using a TextEditor view instead: it also expects to be given a two-way binding to a text string, but it has the additional benefit of allowing multiple lines of text – it’s much better for accepting longer strings from the user.

Mostly because it has nothing special in the way of configuration options, using TextEditor is actually easier than using TextField – you can’t adjust its style or add placeholder text, you just bind it to a string. However, you do need to be careful to make sure it doesn’t go outside the safe area, otherwise typing will be tricky; embed it in a NavigationView, a Form, or similar.


