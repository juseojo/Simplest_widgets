//
//  ContentView.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
			Text("Simplest Widgets")
			Text("Go to home screen\n and add widget")
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
