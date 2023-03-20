//
//  widgetForCalenderApp.swift
//  widgetForCalender
//
//  Created by MD SAZID HASAN DIP on 2023/03/15.
//

import SwiftUI

@main
struct widgetForCalenderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                CalenderView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")

                    }
                StreakView()
                    .tabItem {
                        Label ("Streaks", systemImage: "swift")
                    }
            }
            
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
