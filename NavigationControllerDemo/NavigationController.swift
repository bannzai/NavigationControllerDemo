import SwiftUI

struct NavigationID: Identifiable, Hashable {
  var id: UUID = .init()
}

@Observable class NavigationController {
  var path: NavigationPath = .init()

  @ObservationIgnored 
  fileprivate var destinations: [NavigationID: () -> any View] = [:]

  func push(id: NavigationID = .init(), @ViewBuilder destination: @escaping () -> some View)  {
    destinations[id] = destination
    path.append(id)
  }

  func pop()  {
    path.removeLast()
  }
}

struct WithNavigationModifier: ViewModifier {
  @Bindable var navigationController = NavigationController()

  func body(content: Content) -> some View {
    NavigationStack(path: $navigationController.path) {
      content
        .navigationDestination(for: NavigationID.self) { routeID in
          if let destination = navigationController.destinations[routeID] {
            AnyView(destination().id(routeID))
          }
        }
    }
    .environment(navigationController)
  }
}

extension View {
  func withNavigation() -> some View {
    modifier(WithNavigationModifier())
  }
}
