//
//  Events_AppApp.swift
//  Events App
//
//

import SwiftUI

@main
struct EventAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:[Event.self, Attendee.self])
    }
}
