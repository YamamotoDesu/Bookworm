//
//  ContentView.swift
//  Bookworm
//
//  Created by 山本響 on 2023/03/27.
//

import SwiftUI

struct ContentView: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton(title: "Rember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
