//
//  TemperatureBar_view.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI

struct TemperatureBar_view: View {
	var body: some View {
		let images_manager = Images_manager()
		let homeScreen_image = images_manager.load_image(name: "Home_screen")

		NavigationView {
			VStack{
				Image(uiImage: homeScreen_image)
					.resizable()
					.aspectRatio(contentMode: .fit)
			}.navigationTitle("Temperature Bar")
		}
	}
}

#Preview {
	TemperatureBar_view()
}
