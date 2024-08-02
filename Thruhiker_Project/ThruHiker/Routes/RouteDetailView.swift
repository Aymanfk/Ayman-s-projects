//
//  RouteCardDetailView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/23/24.
//

import SwiftUI

struct RouteCardDetailView: View {
    
    var route: Route
    
    var body: some View {
        if route.name == "Pacific Crest Trail"{
            PCTView().background(Color("softGreen"))
        }
        if route.name == "Appalachian Trail"{
            ATView().background(Color("softGreen"))
        }
        if route.name == "John Muir Trail"{
            JMTView().background(Color("softGreen"))
        }
        if route.name == "Continental Divide Trail"{
            CDTView().background(Color("softGreen"))
        }
        if route.name == "Everest Base Camp"{
            EBCView().background(Color("softGreen"))
        }
        if route.name == "Tour du Mont Blanc"{
            TMBView().background(Color("softGreen"))
        }
    }
    
}




struct PCTView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header image
                Image("pct_header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipped()
                
                // Title
                Text("Pacific Crest Trail")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                
                // Description
                Text("The Pacific Crest Trail (PCT) is a long-distance hiking and equestrian trail that closely aligns with the highest portion of the Sierra Nevada and Cascade mountain ranges, which lie 100 to 150 miles (160 to 240 km) east of the U.S. Pacific coast.")
                    .font(.body)
                    .padding([.leading, .trailing])
                
                // Gallery of images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(1..<4) { index in
                            Image("pct_\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 150)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                
                // Additional information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trail Length: 2,650 miles (4,265 km)")
                        .font(.headline)
                    
                    Text("States: California, Oregon, Washington")
                        .font(.subheadline)
                    
                    Text("Highest Point: Forester Pass, 13,153 feet (4,009 m)")
                        .font(.subheadline)
                    
                    Text("Established: 1968")
                        .font(.subheadline)
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
    }
}




struct ATView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header image
                Image("at_header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipped()
                
                // Title
                Text("Appalachian Trail")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                
                // Description
                Text("The Appalachian Trail is a marked hiking trail in the Eastern United States extending between Springer Mountain in Georgia and Mount Katahdin in Maine. The trail is approximately 2,200 miles (3,500 km) long and passes through 14 states.")
                    .font(.body)
                    .padding([.leading, .trailing])
                
                // Gallery of images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(1..<4) { index in
                            Image("at_\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 150)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                
                // Additional information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trail Length: 2,200 miles (3,500 km)")
                        .font(.headline)
                    
                    Text("States: Georgia, North Carolina, Tennessee, Virginia, West Virginia, Maryland, Pennsylvania, New Jersey, New York, Connecticut, Massachusetts, Vermont, New Hampshire, Maine")
                        .font(.subheadline)
                    
                    Text("Highest Point: Clingmans Dome, 6,643 feet (2,025 m)")
                        .font(.subheadline)
                    
                    Text("Established: 1937")
                        .font(.subheadline)
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
    }
}


struct JMTView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header image
                Image("jmt_header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipped()
                
                // Title
                Text("John Muir Trail")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                
                // Description
                Text("The John Muir Trail is a long-distance hiking trail in the Sierra Nevada mountain range of California, passing through Yosemite, Kings Canyon, and Sequoia National Parks. The trail is 211 miles (340 km) long and features stunning alpine scenery.")
                    .font(.body)
                    .padding([.leading, .trailing])
                
                // Gallery of images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(1..<4) { index in
                            Image("jmt_\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 150)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                
                // Additional information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trail Length: 211 miles (340 km)")
                        .font(.headline)
                    
                    Text("States: California")
                        .font(.subheadline)
                    
                    Text("Highest Point: Mount Whitney, 14,505 feet (4,421 m)")
                        .font(.subheadline)
                    
                    Text("Established: 1915")
                        .font(.subheadline)
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
    }
}


struct CDTView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header image
                Image("cdt_header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipped()
                
                // Title
                Text("Continental Divide Trail")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                
                // Description
                Text("The Continental Divide Trail is a long-distance trail that follows the Continental Divide along the Rocky Mountains and traverses five U.S. states: Montana, Idaho, Wyoming, Colorado, and New Mexico. The trail is approximately 3,100 miles (5,000 km) long.")
                    .font(.body)
                    .padding([.leading, .trailing])
                
                // Gallery of images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(1..<4) { index in
                            Image("cdt_\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 150)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                
                // Additional information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trail Length: 3,100 miles (5,000 km)")
                        .font(.headline)
                    
                    Text("States: Montana, Idaho, Wyoming, Colorado, New Mexico")
                        .font(.subheadline)
                    
                    Text("Highest Point: Grays Peak, 14,278 feet (4,352 m)")
                        .font(.subheadline)
                    
                    Text("Established: 1978")
                        .font(.subheadline)
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
    }
}



struct TMBView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header image
                Image("tmb_header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipped()
                
                // Title
                Text("Tour du Mont Blanc")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                
                // Description
                Text("The Tour du Mont Blanc is one of the most popular long-distance walks in Europe. It circles the Mont Blanc massif, covering a distance of approximately 170 kilometers (110 miles) and passing through France, Italy, and Switzerland.")
                    .font(.body)
                    .padding([.leading, .trailing])
                
                // Gallery of images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(1..<4) { index in
                            Image("tmb_\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 150)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                
                // Additional information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trail Length: 170 kilometers (110 miles)")
                        .font(.headline)
                    
                    Text("Countries: France, Italy, Switzerland")
                        .font(.subheadline)
                    
                    Text("Highest Point: Col des Fours, 2,665 meters (8,743 feet)")
                        .font(.subheadline)
                    
                    Text("Typical Duration: 10-12 days")
                        .font(.subheadline)
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
    }
}

struct EBCView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header image
                Image("ebc_header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipped()
                
                // Title
                Text("Everest Base Camp Trail")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                
                // Description
                Text("The Everest Base Camp (EBC) Trail is a famous trekking route in the Himalayas that takes adventurers to the base of Mount Everest. The trek offers breathtaking views of some of the world's highest peaks and a close-up look at the unique Sherpa culture.")
                    .font(.body)
                    .padding([.leading, .trailing])
                
                // Gallery of images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(1..<4) { index in
                            Image("ebc_\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 150)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                
                // Additional information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trail Length: 130 kilometers (81 miles)")
                        .font(.headline)
                    
                    Text("Country: Nepal")
                        .font(.subheadline)
                    
                    Text("Highest Point: Kala Patthar, 5,545 meters (18,192 feet)")
                        .font(.subheadline)
                    
                    Text("Typical Duration: 12-14 days")
                        .font(.subheadline)
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
    }
}

#Preview {
    RouteCardDetailView(route: routes[1])
}
