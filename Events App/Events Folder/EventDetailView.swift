//
//  EventDetailView.swift
//  Events App

import SwiftUI
import SwiftData

struct Attendee: View {
    let attendee: Attendee
    
    var body: some View {
        HStack(spacing: 16){
            if let avatarData = attendee.avatar, let image = UIImage(data: avatarData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:40, height:40)
                    .clipShape(Circle())
            }else{
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width:40, height:40)
                    .foregroundStyle(.secondary)
            }
            VStack(alignment: .leading){
                Text("\(attendee.firstName) \(attendee.lastName)")
                    .font(.headline)
                
                if attendee.isHost {
                    Text("Host")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}



struct EventDetailView: View {
    @Binding var eevnt: Event
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteConfirmation: Bool = false
    @State private var isEditing: Bool = false
    @State private var editName = ""
    @State private var editStartDate = Date()
    @State private var editEndDate: Date?
    @State private var editLocation = ""
    @State private var editNote = ""
    @State private var showEndDate = false
    
    var body: some View {
        List {
            Section {
                if isEditing {
                    eventEditingFields
                } else {
                    eventDisplayFields
                }
            }
            
            Section {
                ForEach(event.attendees) { attendee in
                    AttendeeRow(attendee: attendee)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                event.attendees.removeAll { $0.id == attendee.id }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                
                Button {
                    showAddAttendee = true
                } label: {
                    Label("Add Attendee", systemImage: "plus.circle.fill")
                }
                .foregroundStyle(.blue)
            } header: {
                Text("Attendees (\(event.attendees.count))")
            }
        }
        .navigationTitle(isEditing ? "Edit Event" : "Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if isEditing {
                    Button("Done") {
                        saveChanges()
                    }
                    .disabled(editName.isEmpty || editLocation.isEmpty)
                } else {
                    Menu {
                        Button {
                            prepareForEditing()
                        } label: {
                            Label("Edit Event", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            showDeleteConfirmation = true
                        } label: {
                            Label("Delete Event", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            
            if isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        discardChanges()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddAttendee) {
            AddAttendeeView(event: event)
                .presentationDetents([.medium])
        }
        .confirmationDialog("Delete Event", isPresented: $showDeleteConfirmation) {
            Button("Delete Event", role: .destructive) {
                modelContext.delete(event)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this event? This action cannot be undone.")
        }
    }
    
    private var eventEditingFields: some View {
        Group {
            TextField("Event Name", text: $editName)
                .font(.title2.weight(.semibold))
            
            DatePicker("Start Date",
                       selection: $editStartDate,
                       displayedComponents: [.date, .hourAndMinute]
            )
            
            Toggle("Add End Date", isOn: $showEndDate)
                .onChange(of: showEndDate) { oldValue, newValue in
                    editEndDate = newValue ? editStartDate.addingTimeInterval(3600) : nil
                }
            
            if showEndDate {
                DatePicker("End Date",
                            selection: Binding(
                                get: { editEndDate ?? editStartDate.addingTimeInterval(3600) },
                            set: { editEndDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            TextField("Location", text: $editLocation)
                .textContentType(.location)
            
            TextField("Notes", text: $editNote, axis: .vertical)
        }
    }
    
    private var eventDisplayFields: some View {
        Group {
            Text(event.name)
                .font(.title2.weight(.semibold))
            
            Label(event.location, systemImage: "mappin.and.ellipse")
                .foregroundStyle(.secondary)
            
            HStack {
                Image(systemName: "calendar")
                Text(event.startDate.formatted(date: .abbreviated, time: .shortened))
                
                if let endDate = event.endDate {
                    Image(systemName: "arrow.right")
                    Text(endDate.formatted(date: .abbreviated, time: .shortened))
                }
            }
            .foregroundStyle(.secondary)
            
            if !event.note.isEmpty {
                Text(event.note)
                    .padding(.vertical)
            }
        }
    }
    
    private func prepareForEditing() {
        editName = event.name
        editStartDate = event.startDate
        editEndDate = event.endDate
        editLocation = event.location
        editNote = event.note
        showEndDate = event.endDate != nil
        isEditing = true
    }
    
    private func saveChanges() {
        event.name = editName
        event.startDate = editStartDate
        event.endDate = editEndDate
        event.location = editLocation
        event.note = editNote
        isEditing = false
    }
    
    private func discardChanges() {
        isEditing = false
    }
}



