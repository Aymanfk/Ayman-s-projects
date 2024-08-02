//
//  ThruHikerApp.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/1/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct ThruHikerApp: App {
    @StateObject private var routeManager = RouteManager(routes: routes)
    @StateObject private var healthKitManager = HealthKitManager()
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView(routeManager: routeManager)
            .environmentObject(routeManager)
            .environmentObject(healthKitManager)
        }
    }
}
