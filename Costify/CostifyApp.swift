//
//  CostifyApp.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
//

import SwiftUI

@main
struct CostifyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
