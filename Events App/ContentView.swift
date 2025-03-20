//
//  ContentView.swift
//  Events App
//
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(filter: #Predicate<Attendee> { $0.isHost }) private var hosts: [Attendee]
    
    var body: some View {
        if let host = hosts.first {
            MainTabView(host: host)
        } else {
            CreateHostView()
        }
    }
}

