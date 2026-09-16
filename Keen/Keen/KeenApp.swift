//
//  KeenApp.swift
//  Keen
//
//  Created by SEIU iMac 4 on 14/09/2026.
//

import SwiftUI

@main
struct KeenApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
