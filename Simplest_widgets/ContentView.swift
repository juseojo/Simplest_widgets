//
//  ContentView.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationView {
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
					Button(action: {
					}, label: {
						ZStack{
							Image("temperature_image")
								.resizable()
								.frame(width: UIScreen.main.bounds.width - 70, height: 125)
								.cornerRadius(10)
							Text("Temperature Bar")
								.font(.largeTitle)
								.fontWeight(.bold)
								.foregroundColor(Color.white)
								.shadow(radius: 2, x: 4, y: 4)
						}
					}).padding(.vertical, 10.0)

					Button(action: {
					}, label: {
						ZStack{
							Image("memo_image")
								.resizable()
								.frame(width: UIScreen.main.bounds.width - 70, height: 125)
								.cornerRadius(10)
							Text("Memo")
								.font(.largeTitle)
								.fontWeight(.bold)
								.foregroundColor(Color.white)
								.shadow(radius: 2, x: 4, y: 4)
						}
					}).padding(.vertical, 10.0)
					Button(action: {
					}, label: {
						ZStack{
							Image("dday_image")
								.resizable()
								.frame(width: UIScreen.main.bounds.width - 70, height: 125)
								.cornerRadius(10)
							Text("D - Day")
								.font(.largeTitle)
								.fontWeight(.bold)
								.foregroundColor(Color.white)
								.shadow(radius: 2, x: 4, y: 4)
						}
					}).padding(.vertical, 10.0)
				}
				.padding()
			}
		}
	}
}

#Preview {
    ContentView()
}
