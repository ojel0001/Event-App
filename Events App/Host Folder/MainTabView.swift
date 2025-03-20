//
//  MainTabView.swift
//  Events App
//
//

import SwiftUI


struct MainTabView: View {
    let host: Attendee
    
    var body: some View {
        TabView{
            EventListView()
                .tabItem {
                    Label("Events", systemImage: "list.bullet")
                }
            
            HostProfileView (host: host)
                .tabItem{
                    Label("profile", systemImage: "person.circle")
            }
        }
    }
}

