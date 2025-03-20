//
//  EventListView.swift
//  Events App
//
//  Created by sunny ojelabi on 2025-03-19.
//

import SwiftUI
import SwiftData


struct EventListView: View {
    @Query(sort:\Event.startDate, order: .forward) private var events: [Event]
    @Query(filter: #Predicate<Attendee> {$0.isHost}) private var hosts: [Attendee]
    @Environment(\.modelContext) private var modelContext
    private var upcomingEvents: [Event] { events.filter {$0.startDate > Date()} }
    private var pastEvents: [Event] { events.filter {$0.startDate <= Date()} }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(upcomingEvents) { event in
                        EventRow(event: event)
                    }
                    .onDelete { indices in
                        indices.forEach { modelContext.delete(upcomingEvents[$0]) }
                    }
                } header: {
                    Text("Upcoming (\(upcomingEvents.count))")
                }
                
                Section {
                    ForEach(pastEvents) { event in
                        EventRow(event: event)
                    }
                    .onDelete { indices in
                        indices.forEach { modelContext.delete(pastEvents[$0]) }
                    }
                } header: {
                    Text("Past (\(pastEvents.count))")
                }
            }
            .navigationTitle("Events")
                      .toolbar {
                          ToolbarItem(placement: .primaryAction) {
                              NavigationLink {
                                  if let host = hosts.first {
                                      AddEventView(host: host) 
                                  } else {
                                      ContentUnavailableView(
                                          "No Host Found",
                                          systemImage: "person.slash",
                                          description: Text("Create a host profile first")
                                      )
                                  }
                              } label: {
                                  Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct EventRow: View {
    let event: Event
    
    var body: some View {
        NavigationLink {
            EventDetailView(event:event)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                
                HStack(spacing: 16) {
                    Label(event.startDate.formatted(date: .abbreviated, time: .shortened),
                          systemImage: "calendar")
                    
                    Label(event.location, systemImage: "mappin.and.ellipse")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
    }
}


#Preview {
    EventListView()
}


