//
//  ContentView.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationStack {
			ScrollView() {
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

					let widgets = ["Temperature Bar", "Memo", "D - Day"]

					// widget buttons
					ForEach(0..<widgets.count) { num in
						NavigationLink(value: widgets[num]) {
							ZStack {
								Image(widgets[num])
									.resizable()
									.frame(width: UIScreen.main.bounds.width - 70, height: 125)
									.cornerRadius(10)
								Text(widgets[num])
									.font(.largeTitle)
									.fontWeight(.bold)
									.foregroundColor(Color.white)
									.shadow(radius: 2, x: 4, y: 4)
							}
						}.padding(.vertical, 10.0)
					}.navigationDestination(for: String.self) { destination in
						if destination == "Temperature Bar" {
							TemperatureBar_view()
						}
						else if destination == "Memo" {

						}
						else if destination == "D - Day" {

						}
					}
				}
			}
		}
	}
}

#Preview {
    ContentView()
}
