//
//  RouteExplorePage.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/22/24.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var routeManager: RouteManager
    @State private var searchText = ""
    @State private var sortOption: SortOption = .none
    let refreshID: UUID

    enum SortOption: String, CaseIterable {
        case none = "None"
        case distanceLowToHigh = "Distance: Low to High"
        case distanceHighToLow = "Distance: High to Low"
    }

    var body: some View {
        VStack {
            Text("Explore Routes")
                .font(.title)
                .bold()
                .padding(.horizontal)

            VStack(alignment: .leading) {
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color("lightBrown"))
                    .cornerRadius(10)
                    .shadow(radius: 20)
                    .frame(maxWidth: .infinity) // Make the TextField take all available space

                HStack {
                    Spacer() // Push the Sort By text and Picker to the right
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("Sort By")
                            .font(.body)
                            .padding(.horizontal, 15)

                        Picker("Sort by", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
            }
            .padding(.horizontal)
            //.padding(.bottom, 10)

            ScrollView {
                LazyVStack(spacing: 20) {
                    if routeManager.exploreRoutes.isEmpty {
                        Text("No remaining hikes to explore. Check back soon.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(sortedRoutes, id: \.id) { route in
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

    private var sortedRoutes: [Route] {
        let filteredRoutes = routeManager.exploreRoutes.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
        }

        switch sortOption {
        case .distanceLowToHigh:
            return filteredRoutes.sorted { $0.distance < $1.distance }
        case .distanceHighToLow:
            return filteredRoutes.sorted { $0.distance > $1.distance }
        case .none:
            return filteredRoutes
        }
    }
}

//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}




//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}
