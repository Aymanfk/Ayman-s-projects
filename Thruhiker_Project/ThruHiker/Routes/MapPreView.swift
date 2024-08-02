

import SwiftUI
@_spi(Experimental) import MapboxMaps



struct MapPreView: View {
    let route: Route
    
    var body: some View {
        Map()
            .mapStyle(MapStyle(uri: StyleURI(rawValue: route.mapURL)!))
        .ignoresSafeArea()
        
    }
}

#Preview {
    MapPreView(route: routes[1])
}
