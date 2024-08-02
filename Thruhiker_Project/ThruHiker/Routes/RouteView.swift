

import SwiftUI

struct RouteView: View {
    
    @State var route: Route
    
    
    var body: some View {
        MapView(route: $route)
     }
}


//#Preview {
//    RouteView(route: routes[1])
//}

