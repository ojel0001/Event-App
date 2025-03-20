//
//  Event.swift
//  Events App
//
//

import SwiftUI
import SwiftData


@Model
class Event {
    @Attribute(.unique) var id: UUID  
    var name: String
    var startDate: Date
    var endDate: Date?
    var location: String
    var note: String
    @Relationship(deleteRule: .cascade) var attendees: [Attendee]
    
    init(
        id: UUID = UUID(),
        name: String,
        startDate: Date,
        endDate: Date? = nil,
        location: String,
        note: String,
        attendees: [Attendee] = []
    ) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.note = note
        self.attendees = attendees
    }
}
