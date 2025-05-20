import SwiftUI

struct ShowModifier<Destination: View>: ViewModifier {
  var isActiveBinding: Binding<Bool>
  var routeStyle: RouteStyle?
  var destination: Destination

  func isActiveBinding(enabled: Bool) -> Binding<Bool> {
    Binding {
      enabled && isActiveBinding.wrappedValue
    } set: {
      guard enabled else { return }
      isActiveBinding.wrappedValue = $0
    }
  }

  func body(content: Content) -> some View {
    content
      .push(isActive: isActiveBinding(enabled: routeStyle?.isPush ?? false), destination: destination)
      .sheet(isActive: isActiveBinding(enabled: routeStyle?.isSheet ?? false), destination: destination)
      .cover(isActive: isActiveBinding(enabled: routeStyle?.isCover ?? false), destination: destination)
      .fullScreenSheet(
        isActive: isActiveBinding(enabled: routeStyle?.isFullScreenSheet ?? false),
        destination: destination
      )
  }
}

extension View {
  func show(isActive: Binding<Bool>, routeStyle: RouteStyle?, destination: some View) -> some View {
    modifier(ShowModifier(isActiveBinding: isActive, routeStyle: routeStyle, destination: destination))
  }
}
