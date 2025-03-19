//
//  MainTabView.swift
//  Events App
//
//  Created by sunny ojelabi on 2025-03-19.
//

import SwiftUI


struct MainTabView: View {

    var body: some View {
        TabView{
            EventListView()
                .tabItem {
                    Label("Events", systemImage: "list.bullet")
                }
            HostProfileView ()
                .tabItem{
                    Label("profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
}
