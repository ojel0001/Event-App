//
//  CreateHostView.swift
//  Events App
//
//  Created by sunny ojelabi on 2025-03-19.
//

import SwiftUI
import PhotosUI


struct CreateHostView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var avatar: Data?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 20) {
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            if let avatarData = avatar, let image = UIImage(data: avatarData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(.borderless)
                        .onChange(of: selectedItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    avatar = data
                                }
                            }
                        }
                        
                        // Name Fields
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("First Name", text: $firstName)
                                .font(.headline)
                            
                            TextField("Last Name", text: $lastName)
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Button("Create Profile") {
                        let host = Attendee(
                            firstName: firstName,
                            lastName: lastName,
                            avatar: avatar,
                            isHost: true
                        )
                        modelContext.insert(host)
                        dismiss()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("New Host Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



