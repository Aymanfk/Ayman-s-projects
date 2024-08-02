//
//  RoutCardView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/20/24.
//

//import SwiftUI
//import HealthKit
//@_spi(Experimental) import MapboxMaps
//
//struct RouteCardView: View {
//    
//    @EnvironmentObject var healthKitManager: HealthKitManager
//    
//    //@State private var sharedState = SharedState()
//    @State var route: Route
//    
//    
//    
//    @State private var latitude: Double = 0.0
//    @State private var longitude: Double = 0.0
//    @State private var Mile: Double = 0.0
//    
//    var body: some View {
//        
//        
//            ZStack {
//                VStack(spacing: 10) {
//                    MapPreView(route: route)
//                        .frame(height: 150)
//                        .cornerRadius(10)
//
//                    VStack(spacing: 5) {
//                        Text(route.name)
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .padding(.bottom, 5)
//                            .foregroundColor(.white)
//                        
//                        HStack {
//                            Text("Distance: \(route.distance) miles")
//                            Spacer()
//                            Text("Time: \(route.time)")
//                        }
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//                    }
//                    .padding()
//                    .background(Color("darkerBrown"))
//                    .cornerRadius(10)
//                    .shadow(radius: 5)
//                    .padding(.bottom, 10)
//                    
//                    HStack(spacing: 20) {
//                        NavigationLink(destination: RouteCardDetailView(route: route)) {
//                            Text("More info")
//                                .foregroundColor(.white)
//                                .padding(.horizontal, 20)
//                                .padding(.vertical, 10)
//                                .background(Color(.brown))
//                                .cornerRadius(10)
//                        }
//                        if route.started == false{
//                            NavigationLink(destination: MapView(route: $route)) {
//                                Text("Start Route")
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 20)
//                                    .padding(.vertical, 10)
//                                    .background(Color("dustyCedar"))
//                                    .cornerRadius(10)
//                            }
//                        }
//                        else {
//                            NavigationLink(destination: MapView(route: $route)) {
//                                Text("View Route")
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 20)
//                                    .padding(.vertical, 10)
//                                    .background(Color("dustyCedar"))
//                                    .cornerRadius(10)
//                            }
//                        }
//                        
//                    }
//                    .padding(.horizontal)
//                }
//                .padding()
//                .background(Color("lightBrown"))
//                .cornerRadius(15)
//                .shadow(radius: 5)
//            }.onAppear{
//                route.started = UserDefaults.standard.bool(forKey: "\(route.name)Started")
//            }
//    }
//}
import SwiftUI
import FirebaseFirestore
import HealthKit
@_spi(Experimental) import MapboxMaps

struct RouteCardView: View {
    @EnvironmentObject var routeManager: RouteManager
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State var route: Route
    let refreshID: UUID

    var body: some View {
        let roundedMiles = String(format: "%.2f", route.distance)
        ZStack {
            VStack(spacing: 10) {
                MapPreView(route: route)
                    .frame(height: 150)
                    .cornerRadius(10)

                VStack(spacing: 5) {
                    Text(route.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Distance: \(roundedMiles) miles")
                        Spacer()
                        Text("Time: \(route.time)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                }
                .padding()
                .background(Color("darkerBrown"))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom, 10)

                HStack(spacing: 10) {
                    NavigationLink(destination: LeaderboardView(route: route)) {
                        Image(systemName: "chart.bar")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: RouteCardDetailView(route: route)) {
                        Text("More info")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.brown)
                            .cornerRadius(10)
                    }

                    if !route.started {
                        NavigationLink(destination: RouteView(route: route)) {
                            Text("Start Route")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color("dustyCedar"))
                                .cornerRadius(10)
                        }
                    } else {
                        if route.completed == true {
                            NavigationLink(destination: RouteView(route: route)) {
                                Text("View Results")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                    .background(Color("dustyCedar"))
                                    .cornerRadius(10)
                            }
                        } else {
                            NavigationLink(destination: RouteView(route: route)) {
                                Text("View Progress")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                    .background(Color("dustyCedar"))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color("lightBrown"))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .onAppear {
            if UserDefaults.standard.object(forKey: "\(route.name)startDate") != nil {
                let startDate = UserDefaults.standard.object(forKey: "\(route.name)startDate") as! Date
                healthKitManager.queryDistanceWalked(from: startDate, route: route.name)
                healthKitManager.queryDistanceWalkedToday(route: route.name)
                
                healthKitManager.calculateDailyAverageDistance(from: startDate, route: route.name)
                healthKitManager.queryStepsWalked(from: startDate, route: route.name)
                healthKitManager.queryStepsWalkedToday(route: route.name)
            }
        }
    }
}


struct User: Identifiable{
    var id: String
    var miles: Double
    var completed: Bool
    var startDate: Date
    var expectedFinish: Date
    var endDate: Date
    var avgDistance: Double
    
    
}

class LeaderboardViewModel: ObservableObject {
    @Published var users = [User]()
    
    func fetchUsers(routeName: String) {
        let db = Firestore.firestore()
        db.collection("routes").document(routeName).collection("users").order(by: "avgDistance", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            self.users = []
            for document in documents{
                let name = document.data()["name"] as? String ?? ""
                let miles = document.data()["miles"] as? Double ?? 0.0
                let avgDistance = document.data()["avgDistance"] as? Double ?? 0.0
                let startStamp = document.data()["startDate"] as? Timestamp ?? Timestamp()
                let startDate = startStamp.dateValue()
                print(startDate)
                let expectedStamp = document.data()["expectedFinish"] as? Timestamp ?? Timestamp()
                let expectedFinish = expectedStamp.dateValue()
                let completed = document.data()["completed"] as? Bool ?? false
                let enddStamp = document.data()["endDate"] as? Timestamp ?? Timestamp()
                let endDate = enddStamp.dateValue()
                self.users.append(User(id: name, miles: miles, completed: completed, startDate: startDate, expectedFinish: expectedFinish, endDate: endDate, avgDistance: avgDistance))
               
            }
            //print(documents.compactMap(<#T##transform: (QueryDocumentSnapshot) throws -> ElementOfResult?##(QueryDocumentSnapshot) throws -> ElementOfResult?#>))
//            self.users = documents.compactMap { document in
//                
//                try? document.data(as: User.self)
//            }
        }
        print(users)
    }
    
}

struct LeaderboardView: View {
    @StateObject var viewModel = LeaderboardViewModel()
    var route: Route
    
    
    
    var body: some View {
        TabView {
            VStack {
                Text("\(route.name)")
                    .font(.title)
                    .bold()
                Text("All-Time Leaderboard")
                    .font(.title)
                    .bold()
                    .padding()

                if viewModel.users.filter ({ $0.completed }).isEmpty {
                    Text("No one has yet finished the \(route.name). Race to be the first!")
                        .padding()
                } else {
                    HStack {
                        Text("Pos.")
                            .font(.subheadline)
                            .bold()
                            .frame(width: 35, alignment: .leading)
                            .padding(.leading)
                        Text("Name")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.horizontal)
                        Text("Pace(mi/day)")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("End Date")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                }
                
                List(Array(viewModel.users.filter { $0.completed }.enumerated()), id: \.element.id) { index, user in
                    HStack {
                        Text("\(index + 1)")
                            .bold()
                            .frame(width: 30, alignment: .leading) // Fixed width for alignment
                        Text(user.id)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.footnote)
                        Text(String(format: "%.2f", user.avgDistance))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.footnote)
                        Text(user.endDate, style: .date)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.footnote)
                    }
                    .listRowBackground(Color("lightBrown"))
                }
                .background(Color("softGreen"))
                .scrollContentBackground(.hidden)
            }
            .background(Color("softGreen"))
            .tabItem {
                Label("All-Time", systemImage: "trophy")
            }
            
            VStack {
                Text("\(route.name)")
                    .font(.title)
                    .bold()
                Text("Current Standings")
                    .font(.title)
                    .bold()
                    .padding()

                if viewModel.users.filter ({ !$0.completed }).isEmpty {
                    Text("No one is currently hiking the \(route.name). Take the trail less followed.")
                        .padding()
                } else {
                    HStack {
                        Text("Pos.")
                            .font(.subheadline)
                            .bold()
                            .frame(width: 35, alignment: .leading)
                            .padding(.leading)
                        Text("Name")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            //.padding(.horizontal)
                        Text("Miles")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Start Date")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Expected Finish")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    
                    
                    //.listRowBackground(Color("softGreen"))
                }
                List(Array(viewModel.users.filter { !$0.completed }.enumerated()), id: \.element.id) { index, user in
                    HStack {
                        Text("\(index + 1)")
                            .bold()
                            .frame(width: 30, alignment: .leading) // Fixed width for alignment
                        Text(user.id)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.footnote)
                        Text(String(format: "%.2f", user.miles))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.footnote)
                        Text(user.startDate, style: .date)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.footnote)
                        if user.avgDistance == 0.0{
                            Text("TBD")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.footnote)
                        }
                        else{
                            Text(user.expectedFinish, style: .date)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.footnote)
                        }
                        
                    }
                    .listRowBackground(Color("lightBrown"))
                }
                .background(Color("softGreen"))
                

                .scrollContentBackground(.hidden)
            }
            .background(Color("softGreen"))
            .tabItem {
                Label("Current", systemImage: "clock")
            }
        }
        //.background(Color("lightBrown"))
        .onAppear {
            viewModel.fetchUsers(routeName: route.name)
        }
    }
}




//struct RouteCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        RouteCardView(route: routes[1])
//            .previewLayout(.sizeThatFits)
//    }
//}
