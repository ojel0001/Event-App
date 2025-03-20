//
//  Events_AppApp.swift
//  Events App
//
//

import SwiftUI

@main
struct Events_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:[Event.self, Attendee.self])
    }
}
