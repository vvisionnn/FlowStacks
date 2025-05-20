import Presentation
import SwiftUI

struct FullScreenSheetModifier<Destination: View>: ViewModifier {
  var isActiveBinding: Binding<Bool>
  var destination: Destination

  func body(content: Content) -> some View {
    #if os(macOS) // Covers are unavailable on macOS
      content
        .sheet(
          isPresented: isActiveBinding,
          onDismiss: nil,
          content: { destination.environment(\.parentNavigationStackType, nil) }
        )
    #else
      content
        .presentation(
          isPresented: isActiveBinding,
          transition: .interactiveFullSheet,
          destination: { destination.environment(\.parentNavigationStackType, nil) }
        )
    #endif
  }
}

extension View {
  func fullScreenSheet(isActive: Binding<Bool>, destination: some View) -> some View {
    modifier(FullScreenSheetModifier(isActiveBinding: isActive, destination: destination))
  }
}
