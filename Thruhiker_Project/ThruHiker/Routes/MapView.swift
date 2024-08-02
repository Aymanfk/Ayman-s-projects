//
//  MapView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/8/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps
import FirebaseFirestore
//import FirebaseFirestoreSwift






struct MapView: View {
    
    
    
    @EnvironmentObject var healthKitManager: HealthKitManager
    @AppStorage("userName") private var userName: String?
    @StateObject var LviewModel = LeaderboardViewModel()
    
    //@Binding var sharedState: SharedState
    @Binding var route: Route
    
    @State private var showSheet = false
    @State private var showPopover = false
    @State private var showLeaderBoardSheet = false
    
    @StateObject var viewModel = WeatherViewModel()
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var Mile: Double = 0.0
    @State private var MileToday: Double = 0.0
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    
    @State var expectedEndDate: Date = Date()
    @State var avgDistance: Double = 0.0
    @State var stepsWalked: Double = 0.0
    @State var stepsWalkedToday: Double = 0.0
    
    //@State var userID: UUID = UUID()
    
    
    
    func saveToFirebase() {
        let userID = UserDefaults.standard.string(forKey: "userID")
        let db = Firestore.firestore()
        let document = db.collection("routes")
                         .document(route.name)
                         .collection("users")
                         .document(userID!)// Document ID is the name

        document.setData([
            "name": userName!,
            "miles": Mile,
            "avgDistance": avgDistance,
            "startDate": self.startDate,
            "completed": route.completed,
            "expectedFinish": self.expectedEndDate,
            "endDate": endDate
        ])
    }
    
    
    
    var body: some View {
        ZStack {
            Map(){
                CircleAnnotation(centerCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    .circleColor(StyleColor(.systemBlue))
                    .circleRadius(7)
                    .circleStrokeColor(StyleColor(.white))
                    .circleStrokeWidth(1)
                
            }
            
            .mapStyle(MapStyle(uri: StyleURI(rawValue: route.mapURL)!))
            .ornamentOptions(OrnamentOptions(
                scaleBar: ScaleBarViewOptions(visibility: .adaptive),
                compass: CompassViewOptions(position: .bottomLeading, visibility: .hidden)
                ))

            .ignoresSafeArea()
            .onAppear {
                //load state
                latitude = UserDefaults.standard.double(forKey: "\(route.name)latitude")
                longitude = UserDefaults.standard.double(forKey: "\(route.name)longitude")
                //Mile = UserDefaults.standard.double(forKey: "\(route.name)Mile")
    //            Mile = UserDefaults.standard.double(forKey: "\(route.name)Mile")
                //startDate = UserDefaults.standard.object(forKey: "\(route.name)startDate") as! Date
                
    //            healthKitManager.queryDistanceWalked(from: self.startDate)
                viewModel.fetchWeather(lat: latitude, lon: longitude)
                
                if route.started == false{
                    self.startDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())!
                    route.started = true
                }
                else{
                    print("old date")
                    startDate = UserDefaults.standard.object(forKey: "\(route.name)startDate") as! Date
                }
                print("start date: \(self.startDate)")
                
//                healthKitManager.queryDistanceWalked(from: self.startDate, route: route.name)
//                
//                healthKitManager.calculateDailyAverageDistance(from: self.startDate)
                
    //            group.notify(queue: .main) {
    //                Mile = healthKitManager.distanceWalked
    //            }
    //            healthKitManager.queryDistanceWalked(from: self.startDate)
                
                Mile = UserDefaults.standard.double(forKey: "\(route.name)Mile")
                
                if route.completed == false{
                    
                    var newDistance = 0.0
                    if route.name == "Pacific Crest Trail"{
                        newDistance = healthKitManager.PCTdistanceWalked
                        self.avgDistance = healthKitManager.PCTAvg
                        self.stepsWalked = healthKitManager.PCTSteps
                        self.stepsWalkedToday = healthKitManager.PCTStepsToday
                        self.MileToday = healthKitManager.PCTdistanceWalkedToday
                        
                    }
                    if route.name == "Appalachian Trail"{
                        newDistance = healthKitManager.ATdistanceWalked
                        self.avgDistance = healthKitManager.ATAvg
                        self.stepsWalked = healthKitManager.ATSteps
                        self.stepsWalkedToday = healthKitManager.ATStepsToday
                        self.MileToday = healthKitManager.ATdistanceWalkedToday
                    }
                    if route.name == "John Muir Trail"{
                        newDistance = healthKitManager.JMTdistanceWalked
                        self.avgDistance = healthKitManager.JMTdAvg
                        self.stepsWalked = healthKitManager.JMTdSteps
                        self.stepsWalkedToday = healthKitManager.JMTdStepsToday
                        self.MileToday = healthKitManager.JMTdistanceWalkedToday
                    }
                    if route.name == "Everest Base Camp"{
                        newDistance = healthKitManager.EverestdistanceWalked
                        self.avgDistance = healthKitManager.EverestAvg
                        self.stepsWalked = healthKitManager.EverestSteps
                        self.stepsWalkedToday = healthKitManager.EverestStepsToday
                        self.MileToday = healthKitManager.EverestdistanceWalkedToday
                    }
                    if route.name == "Continental Divide Trail"{
                        newDistance = healthKitManager.CDdistanceWalked
                        self.avgDistance = healthKitManager.CDAvg
                        self.stepsWalked = healthKitManager.CDSteps
                        self.stepsWalkedToday = healthKitManager.CDStepsToday
                        self.MileToday = healthKitManager.CDdistanceWalkedToday
                    }
                    if route.name == "Tour du Mont Blanc"{
                        newDistance = healthKitManager.TMBdistanceWalked
                        self.avgDistance = healthKitManager.TMBAvg
                        self.stepsWalked = healthKitManager.TMBSteps
                        self.stepsWalkedToday = healthKitManager.TMBStepsToday
                        self.MileToday = healthKitManager.TMBdistanceWalkedToday
                    }
                    //let newDistance = healthKitManager.distanceWalked
                    
                    
                    if newDistance > Mile{
                        Mile = newDistance
                    }
                    
                    
                    //for testing
                    
//                    Mile = 1027.22
//                    self.avgDistance = 5.62860273973
//                    self.stepsWalked = 2054440
//                    self.stepsWalkedToday = 12260
//                    self.MileToday = 6.13
                    
                    
                    if avgDistance > 0.0{
                        let daysRemaining = route.distance / avgDistance
                        
                        

                        expectedEndDate = Calendar.current.date(byAdding: .day, value: Int(daysRemaining), to: Date())!
                    }
                    
                    
                    
                }

                
                
                if Mile >= Double(route.distance){
                    route.completed = true
                    self.endDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())!
                    Mile = Double(Int(route.distance))
                }
                print(Mile)
                if let (long, lat) = JSONManager.getCoord(for: Mile, from: route.mileMarkerFile) {
                    self.longitude = long
                    self.latitude = lat
                    print(long)
                    print(lat)
                }
                
                
                //store state
                UserDefaults.standard.set(latitude, forKey: "\(route.name)latitude")
                UserDefaults.standard.set(longitude, forKey: "\(route.name)longitude")
                UserDefaults.standard.set(Mile, forKey: "\(route.name)Mile")
                UserDefaults.standard.set(startDate, forKey: "\(route.name)startDate")
                UserDefaults.standard.set(route.completed, forKey: "\(route.name)Completed")
                UserDefaults.standard.set(route.started, forKey: "\(route.name)Started")
                
                saveToFirebase()
            }
            
            
            
            
            
            
//            Button {
//                showSheet.toggle()
//            } label: {
//                Image(systemName: "photo.fill.on.rectangle.fill")
//                    .resizable()
//                    .backgroundStyle(.white)
//                    .frame(width: 70, height: 70)  // Adjust the width and height as needed
//                    //.foregroundColor(.red)
//            }.offset(y: 320)
//            .sheet(isPresented: $showSheet) {
//                SheetView(latitude: latitude, longitude: longitude) // Example coordinates for San Francisco
//            }
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Spacer()
                        Button {
                            showSheet.toggle()
                        } label: {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .resizable()
                                .foregroundStyle(.blue)
                                .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)
                                .padding(10)
                        }
                        .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)
                        .offset(y: -20)

                        Spacer() // Spacer between buttons

                        Button {
                            showPopover.toggle()
                        } label: {
                            Image(systemName: "chart.bar.xaxis")
                                .resizable()
                                .foregroundStyle(.blue)
                                .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                                .padding(10)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)
                        )
                        .offset(y: -20)
                        .padding(.trailing, 20)
//                        .padding(.bottom, 20)
                        //Spacer() // Spacer to ensure the HStack is full width
                    }
                    .frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showSheet) {
                SheetView(latitude: latitude, longitude: longitude, route: route)
            }
            
//            if showPopover {
//                            Color.black.opacity(0.4) // Optional: dim background
//                                .edgesIgnoringSafeArea(.all)
//                                .onTapGesture {
//                                    showPopover = false
//                                }
//
//                            VStack {
//                                
//                                VStack {
//                                    HStack {
//                                        Spacer()
//                                        Button(action: {
//                                            showPopover = false
//                                        }) {
//                                            Image(systemName: "xmark")
//                                                .foregroundColor(.white)
//                                                //.padding()
//                                                .frame(width: 30, height: 30)
//                                                .background(Color.red)
//                                                .clipShape(Circle())
//                                        }
//                                    }
//                                    //.padding([.top, .trailing])
//
//                                    Text("Statistics")
//                                        .font(.title)
//                                        .bold()
//                                        .padding()
//                                    
////                                    let formatter = DateFormatter()
////                                    formatter.dateStyle = .medium
////                                    let simpleStart = formatter.string(from: self.startDate)
////                                    let simpleEnd = formatter.string(from: self.expectedEndDate)
//                                    
//                                    
//                                    Text("Start Date: \(startdateFormatted)")
//                                    if route.completed == true {
//                                        Text("Finished On: \(enddateFormatted)")
//                                        Text("Miles Completed: \(Int(self.Mile))")
//                                    }
//                                    else{
//                                        if self.Mile == 0.0{
//                                            Text("Expected Finish: Not Enough Data")
//                                        }
//                                        else{
//                                            Text("Expected Finish: \(enddateFormatted)")
//                                            
//                                            
//                                            
//                                        }
//                                        Text("Miles today: \(Int(self.MileToday))")
//                                        Text("Steps today: \(Int(self.stepsWalkedToday))")
//                                        
//                                        Text("Miles Completed: \(Int(self.Mile))")
//                                        Text("Miles Remaining: \(Int(route.distance - self.Mile))")
//                                    }
//                                    
//                                    Text("Average Mileage: \((String(format: "%.2f", self.avgDistance)))")
//                                    Text("Total Steps: \(Int(self.stepsWalked))")
////                                    Text("Expected Finish: \(self.expectedEndDate)")
//                                    //Text("Miles today: ")
//                                    //Text("Most miles in day: ")
//                                    
//                                    Spacer()
//                                }
//                                .padding()
//                                .frame(width: 300, height: 350)
//                                .background(.softGreen)
//                                .cornerRadius(15)
//                                .shadow(radius: 10)
//                            }
//                            .transition(.scale)
//                        }
//
//

            if showPopover {
                ZStack {
                    Color.black.opacity(0.4) // Optional: dim background
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showPopover = false
                        }

                    VStack {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    showPopover = false
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                }
                            }
                            Text("Statistics")
                                .font(.title)
                                .bold()
                                .padding()
                            
                            Text("Start Date: \(startdateFormatted)")
                            if route.completed == true {
                                Text("Finished On: \(enddateFormatted)")
                                Text("Miles Completed: \((String(format: "%.2f", self.Mile)))")
                            } else {
                                if self.Mile == 0.0 {
                                    Text("Expected Finish: Not Enough Data")
                                } else {
                                    Text("Expected Finish: \(enddateFormatted)")
                                }
                                Text("Miles today: \((String(format: "%.2f", self.MileToday)))")
                                Text("Steps today: \(Int(self.stepsWalkedToday))")
                                Text("Miles Completed: \((String(format: "%.2f", self.Mile)))")
                                Text("Miles Remaining: \(Int(route.distance - self.Mile))")
                            }
                            Text("Average Mileage: \((String(format: "%.2f", self.avgDistance)))")
                            Text("Total Steps: \(Int(self.stepsWalked))")
                            Spacer()
                        }
                        .padding()
                        .frame(width: 300, height: 350)
                        .background(Color.softGreen)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .overlay{
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        showLeaderBoardSheet = true
                                    }) {
                                        Image(systemName: "trophy")
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                            //.padding()
                                    }
                                    .sheet(isPresented: $showLeaderBoardSheet) {
                                        // Your sheet content here
                                        VStack {
                                            Text("\(route.name)")
                                                .font(.title)
                                                .bold()
                                                .padding()
                                            Text("Current Standings")
                                                .font(.title)
                                                .bold()
                                                .padding()

                                            if LviewModel.users.filter ({ !$0.completed }).isEmpty {
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
                                            List(Array(LviewModel.users.filter { !$0.completed }.enumerated()), id: \.element.id) { index, user in
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
                                        .onAppear {
                                            LviewModel.fetchUsers(routeName: route.name)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    
                }
                .transition(.scale)
            }

            
            GeometryReader { geometry in
                        VStack {
                            HStack {
                                Spacer()
                                VStack(spacing: 0) {
                                    if let iconURL = viewModel.weatherIconURL {
                                        AsyncImage(url: iconURL) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: geometry.size.width * 0.20, height: geometry.size.width * 0.20)
                                    } else {
                                        Text("Loading...")
                                    }

                                    if let temperature = viewModel.temperature {
                                        Text("\(temperature, specifier: "%.1f") °F")
                                            .font(.title)
                                            .padding(.horizontal)
                                    } else {
                                        Text("Loading temperature...")
                                    }
                                }
                                .padding(.top, 20) // Adjust the padding to add space from the top edge
                                .padding(.trailing, 20) // Adjust the padding to add space from the right edge
                            }
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewModel.fetchWeather(lat: latitude, lon: longitude) // Example coordinates
                    }
            
            
            
            GeometryReader { geometry in
                        HStack {
                            VStack {
                                Spacer()
                                progressBar(progress: $Mile, totalDistance: $route.distance)
                                    .frame(width: geometry.size.height * 0.01, height: geometry.size.height * 0.4)
                                    .padding(.leading, 20) // Adjust the padding to add space from the left edge
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .edgesIgnoringSafeArea(.all)
        }
        var startdateFormatted: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
        return formatter.string(from: self.startDate)
        }
        var enddateFormatted: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if route.completed == false {
                return formatter.string(from: self.expectedEndDate)
            }
            else{
                return formatter.string(from: self.expectedEndDate)
            }
        
        }
        
        
    }
}



struct IdentifiableInt: Identifiable {
    var id: Int
}

struct SheetView: View {
    @ObservedObject var viewModel = FlickrViewModel()
    @State private var selectedPhotoIndex: IdentifiableInt?
    let latitude: Double
    let longitude: Double
    let route: Route

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack {
            Text("Daily Scenary")
                .font(.title)
                .bold()
                .padding()
                .foregroundStyle(.black)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.photos.indices, id: \.self) { index in
                        if let url = URL(string: viewModel.photos[index].imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        selectedPhotoIndex = IdentifiableInt(id: index)
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 170, height: 170)
                            .cornerRadius(8)
                            .padding(5)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchPhotos(latitude: latitude, longitude: longitude)
        }
        .fullScreenCover(item: $selectedPhotoIndex) { identifiableIndex in
            FullScreenImageView(viewModel: viewModel, selectedPhotoIndex: identifiableIndex.id)
        }
        .background(Color("softGreen"))
    }
}






struct FullScreenImageView: View {
    @ObservedObject var viewModel: FlickrViewModel
    @State private var selectedPhotoIndex: Int
    @Environment(\.presentationMode) var presentationMode

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    init(viewModel: FlickrViewModel, selectedPhotoIndex: Int) {
        self.viewModel = viewModel
        self._selectedPhotoIndex = State(initialValue: selectedPhotoIndex)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    if let url = URL(string: "https://farm\(viewModel.photos[selectedPhotoIndex].farm).staticflickr.com/\(viewModel.photos[selectedPhotoIndex].server)/\(viewModel.photos[selectedPhotoIndex].id)_\(viewModel.photos[selectedPhotoIndex].secret)_b.jpg") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(scale)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            scale = lastScale * value
                                            if scale < 1.0{
                                                scale = 1.0
                                            }
                                        }
                                        .onEnded { _ in
                                            lastScale = scale
                                        }
                                )
                                .overlay(
                                    HStack {
                                        Button(action: {
                                            selectedPhotoIndex = max(selectedPhotoIndex - 1, 0)
                                            resetScale()
                                        }) {
                                            Image(systemName: "chevron.left.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color("lightBrown"))
                                        }
                                        .disabled(selectedPhotoIndex == 0)

                                        Spacer()

                                        Button(action: {
                                            selectedPhotoIndex = min(selectedPhotoIndex + 1, viewModel.photos.count - 1)
                                            resetScale()
                                        }) {
                                            Image(systemName: "chevron.right.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color("lightBrown"))
                                        }
                                        .disabled(selectedPhotoIndex == viewModel.photos.count - 1)
                                    }
                                    .padding(.horizontal),
                                    alignment: .center
                                )
                                .overlay(
                                    VStack {
                                        HStack {
                                            Spacer()

                                            Button(action: {
                                                presentationMode.wrappedValue.dismiss()
                                            }) {
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .frame(width: 30, height: 30)
                                                    .background(Color.red)
                                                    .clipShape(Circle())
                                            }
                                        }
                                        Spacer()
                                    },
                                    alignment: .topTrailing
                                )
                        } placeholder: {
                            ProgressView()
                                .edgesIgnoringSafeArea(.all)
                        }
                    }

                    Spacer()
                }
            }
        }
    }

    private func resetScale() {
        scale = 1.0
        lastScale = 1.0
    }
}

struct progressBar: View {
    @Binding var progress: Double
    @Binding var totalDistance: Double

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width, height: getProg(in: geometry.size))
                    
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height-7)
            .background(Color.gray.opacity(0.9))
            .cornerRadius(5)
        }
 
    }

    private func getProg(in size: CGSize) -> CGFloat {
        return size.height * CGFloat(progress / totalDistance)
    }
}




//#Preview {
//    MapView(route: routes[1])
//}
