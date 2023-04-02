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

## [How to combine Core Data and SwiftUI](https://www.hackingwithswift.com/books/ios-swiftui/how-to-combine-core-data-and-swiftui)

<img width="300" alt="スクリーンショット 2023-03-27 15 44 48" src="https://user-images.githubusercontent.com/47273077/227876405-1ec2fcc4-d35b-45de-b0dc-cdd02930bd6c.gif">

DataController.swift
BookwormApp.swift
```swift
@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

```

ContentView.swift
```swift
struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
    
    var body: some View {
        VStack {
            List(students) { student in
                Text(student.name ?? "Unknown")
            }
            
            Button("Add") {
                let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
                
                let chosenFirstName = firstNames.randomElement()!
                let chosenLastName = lastNames.randomElement()!
                
                let student = Student(context: moc)
                student.id = UUID()
                student.name = "\(chosenFirstName) \(chosenLastName)"
                try? moc.save()
            }
        }
    }
}
```

Bookworm.xcdatamodeld
<img width="840" alt="スクリーンショット 2023-03-27 16 54 48" src="https://user-images.githubusercontent.com/47273077/227876954-aca93b4c-bfa6-4786-9514-974da29607c7.png">

## [Creating books with Core Data](https://www.hackingwithswift.com/books/ios-swiftui/creating-books-with-core-data)

<img width="300" alt="スクリーンショット 2023-03-30 18 43 51" src="https://user-images.githubusercontent.com/47273077/228798783-2134da5e-f03a-4c11-a8f1-263bf3074637.gif">

<img width="717" alt="スクリーンショット 2023-03-30 18 43 51" src="https://user-images.githubusercontent.com/47273077/228796961-1dc4bcf5-6788-4ec7-acc0-29e5d6c664c9.png">

AddBookView.swift
```swift
import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author of book", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    Picker("Rating", selection: $rating) {
                        ForEach(0..<6) {
                            Text(String($0))
                        }
                    }
                } header: {
                    Text("write a review")
                }
                
                Section {
                    Button("Save") {
                        // add the book
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.rating = Int16(rating)
                        newBook.review = review
                        
                        try? moc.save()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
}
```

ContentView.swift
```swift
struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            Text("Count: \(books.count)")
                .navigationTitle("Bookworm")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView()
                }
        }
    }
}
```

## [Adding a custom star rating component](https://www.hackingwithswift.com/books/ios-swiftui/adding-a-custom-star-rating-component)

<img width="300" alt="スクリーンショット 2023-03-30 18 43 51" src="https://user-images.githubusercontent.com/47273077/228983603-4e0b9369-4c61-42fe-848a-1a6e501f5a49.gif">

RatingView.swift
```swift
import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
```

AddBookView.swift
```swift
struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
        
        ------------中略----------------
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)


```

SwiftUI has a specific and simple solution for this called constant bindings. These are bindings that have fixed values, which on the one hand means they can’t be changed in the UI, but also means we can create them trivially – they are perfect for previews.            

## [Building a list with @FetchRequest](https://www.hackingwithswift.com/books/ios-swiftui/building-a-list-with-fetchrequest)

<img width="300" alt="スクリーンショット 2023-03-31 8 33 57" src="https://user-images.githubusercontent.com/47273077/228987485-0cf52617-839b-4606-b221-b80900d1868b.png">

EmojiRatingView.swift
```swift
import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16
    
    var body: some View {
        switch rating {
        case 1:
            return Text("🙈")
        case 2:
            return Text("😔")
        case 3:
            return Text("🙂")
        case 4:
            return Text("😊")
        default:
            return Text("🤩")
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
```

ContentView.swift
```swift
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        Text(book.title ?? "Unknown Title")
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
}
```

## [Showing book details](https://www.hackingwithswift.com/books/ios-swiftui/showing-book-details)

<img width="514" alt="スクリーンショット 2023-03-31 9 42 07" src="https://user-images.githubusercontent.com/47273077/228994648-912733a7-baf8-4cb2-9770-b50d3ff52a15.png">

DetailView.swift
```swift
import SwiftUI

struct DetailView: View {
    let book: Book
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(book.author ?? "Unknown Author")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text(book.review ?? "No review")
                .padding()
            
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
    }
}

```

## [Sorting fetch requests with SortDescriptor](https://www.hackingwithswift.com/books/ios-swiftui/sorting-fetch-requests-with-sortdescriptor)

```swift
struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
//        SortDescriptor(\.title, order: .reverse)
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
```

## [Deleting from a Core Data fetch request](https://www.hackingwithswift.com/books/ios-swiftui/deleting-from-a-core-data-fetch-request)

ContentView.swift
```swift
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
    
        try? moc.save()
    }
 ```
