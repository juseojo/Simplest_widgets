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
				.font(.largeTitle)
				.fontWeight(.bold)
				.padding(.bottom)
			Text("Go to home screen\n and add widget")
				.font(.title2)
				.fontWeight(.semibold)
				.foregroundColor(Color.gray)
				.multilineTextAlignment(.center)
			Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
