//
//  MainView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/11/24.
//
import SwiftUI


struct MainView: View {
    @ObservedObject var routeManager: RouteManager
    @State private var refreshID = UUID()
    @State private var selectedTab: Tab = .explore
    @State private var showNamePrompt = false
    @AppStorage("userName") private var userName: String?

    enum Tab {
        case explore, inProgress, completed
    }

    init(routeManager: RouteManager) {
        self.routeManager = routeManager
        _selectedTab = State(initialValue: routeManager.inProgressRoutes.isEmpty ? .explore : .inProgress)
                
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("softGreen"))
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    ExploreView(refreshID: refreshID)
                        .tabItem {
                            Label("Explore", systemImage: "magnifyingglass")
                        }
                        .tag(Tab.explore)
                    InProgressView(refreshID: refreshID)
                        .tabItem {
                            Label("In Progress", systemImage: "clock")
                        }
                        .tag(Tab.inProgress)
                    CompletedView(refreshID: refreshID)
                        .tabItem {
                            Label("Completed", systemImage: "checkmark")
                        }
                        .tag(Tab.completed)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ThruHiker")
                        .font(.title)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        refreshID = UUID()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if userName == nil {
                    showNamePrompt = true
                }
            }
            .overlay(
                showNamePrompt ? NamePromptOverlay(showNamePrompt: $showNamePrompt, userName: $userName) : nil
            )
        }
    }
}

struct NamePromptOverlay: View {
    @Binding var showNamePrompt: Bool
    @Binding var userName: String?
    @State private var enteredName = ""
    @State private var showError = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // No action to close on tap outside
                }

            VStack {
                VStack {
                    Text("Welcome to ThruHiker!")
                        .font(.title3)
                        .bold()
                        .padding()
                    
                    Text("Before you hit the trail, enter your name. This is how you will appear to others on leaderboards.")
                        .font(.body)
                    
                    
                    TextField("Name", text: $enteredName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(enteredName.isEmpty ? Color.red : Color.gray, lineWidth: 1)
                        )
                        .padding()

                    Button(action: {
                        if enteredName.isEmpty {
                            showError = true
                        } else {
                            userName = enteredName
                            UserDefaults.standard.set(UUID().uuidString, forKey: "userID")
                            showNamePrompt = false
                        }
                    }) {
                        Text("Confirm")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(enteredName.isEmpty)
                    
                    //Spacer()
                }
                .padding()
                .frame(width: 300, height: 350)
                .background(Color("softGreen"))
                .cornerRadius(15)
                .shadow(radius: 10)
            }
            .transition(.scale)
        }
    }
}




//#Preview {
//    MainView()
//}
