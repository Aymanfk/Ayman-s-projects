//
//  RouteExplorePage.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/22/24.
//

import SwiftUI

struct InProgressView: View {
    @EnvironmentObject var routeManager: RouteManager
    let refreshID: UUID
    

    var body: some View {
        VStack {
            Text("In Progress Routes")
                .font(.title)
                .bold()
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 20) {
                    if routeManager.inProgressRoutes.isEmpty {
                        Text("No routes in progress. Check out the explore page to start your next ThruHike!")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    else{
                        ForEach(routeManager.inProgressRoutes, id: \.id) { route in
                            RouteCardView(route: route, refreshID: refreshID)
                                .padding(5)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .background(Color.clear)
                        }
                    }
                    
                }
                .padding()
            }
            .background(Color.clear)
            .listStyle(PlainListStyle())
        }
        .background(Color("softGreen"))
    }
}

//#Preview {
//    InProgressView()
//}
