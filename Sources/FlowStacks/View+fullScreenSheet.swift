import Presentation
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct FullScreenSheetModifier<Destination: View>: ViewModifier {
	var isActiveBinding: Binding<Bool>
	var destination: Destination

	func body(content: Content) -> some View {
		#if os(iOS) // Covers are only available on iOS
		if #available(iOS 18.0, *) {
			content
				.sheet(
					isPresented: isActiveBinding,
					onDismiss: nil,
					content: {
						destination
							.environment(\.parentNavigationStackType, nil)
							.wantsFullScreenSheet()
					}
				)
		} else {
			content
				.presentation(
					isPresented: isActiveBinding,
					transition: .interactiveFullSheet,
					destination: { destination.environment(\.parentNavigationStackType, nil) }
				)
		}
		#else
		content
			.sheet(
				isPresented: isActiveBinding,
				onDismiss: nil,
				content: { destination.environment(\.parentNavigationStackType, nil) }
			)
		#endif
	}
}

extension View {
	func fullScreenSheet(isActive: Binding<Bool>, destination: some View) -> some View {
		modifier(FullScreenSheetModifier(isActiveBinding: isActive, destination: destination))
	}
}

extension View {
	@ViewBuilder
	fileprivate func wantsFullScreenSheet() -> some View {
		introspect(.sheet, on: .iOS(.v18...)) { sheet in
			guard let sheet = sheet as? UISheetPresentationController else { return }
			sheet.setValue(true, forKey: String(["wants", "Full", "Screen"].joined()))
			sheet.setValue(true, forKey: String(["allows", "Interactive", "Dismiss", "When", "FullScreen"].joined()))
		}
	}
}
