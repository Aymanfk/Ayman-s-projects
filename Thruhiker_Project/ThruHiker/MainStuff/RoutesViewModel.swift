import SwiftUI
import Combine

class RouteManager: ObservableObject {
    @Published var routes: [Route]

    init(routes: [Route]) {
        self.routes = routes
    }

    func updateRouteStatus(routeID: UUID, started: Bool) {
        guard let index = routes.firstIndex(where: { $0.id == routeID }) else { return }
        routes[index].started = started
        self.objectWillChange.send()
    }

    var inProgressRoutes: [Route] {
        routes.filter { $0.started && !$0.completed }
    }

    var completedRoutes: [Route] {
        routes.filter { $0.completed }
    }

    var exploreRoutes: [Route] {
        routes.filter { !$0.started }
    }
}
