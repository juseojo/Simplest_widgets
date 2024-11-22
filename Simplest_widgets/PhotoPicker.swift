import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
	@Binding var selectedImageData: Data?
	let onImagePicked: () -> Void

	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()

		config.selectionLimit = 1
		config.filter = .images

		let picker = PHPickerViewController(configuration: config)

		picker.delegate = context.coordinator

		return picker
	}

	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}

	class Coordinator: NSObject, PHPickerViewControllerDelegate {
		let parent: PhotoPicker

		init(_ parent: PhotoPicker) {
			self.parent = parent
		}

		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			picker.dismiss(animated: true)

			guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
				return
			}

			provider.loadObject(ofClass: UIImage.self) { image, error in
				guard let uiImage = image as? UIImage else { return }
				DispatchQueue.main.async {
					self.parent.selectedImageData = uiImage.jpegData(compressionQuality: 1.0)
					self.parent.onImagePicked()
				}
			}
		}
	}
}
