//
//  AddEventView.swift
//  Events App
//
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let host: Attendee  
    
    @State private var name = ""
    @State private var startDate = Date()
    @State private var endDate: Date?
    @State private var location = ""
    @State private var note = ""
    @State private var showEndDatePicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Event Details") {
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    Toggle("Add End Date", isOn: $showEndDatePicker)
                    if showEndDatePicker {
                        DatePicker("End Date", selection: Binding<Date>(
                            get: { endDate ?? startDate.addingTimeInterval(3600) },
                            set: { endDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute])
                    }
                    TextField("Note", text: $note, axis: .vertical)
                }
                
                Section {
                    Button("Create Event") {
                        let event = Event(
                            name: name,
                            startDate: startDate,
                            endDate: endDate,
                            location: location,
                            note: note,
                            attendees: [host]
                        )
                        modelContext.insert(event)
                        dismiss()
                    }
                    .disabled(name.isEmpty || location.isEmpty)
                }
            }
            .navigationTitle("New Event")
        }
    }
}


#Preview {
    AddEventView()
}
