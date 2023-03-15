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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
