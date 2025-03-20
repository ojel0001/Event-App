//
//  HostProfileView.swift
//  Events App
//
//

import SwiftUI
import PhotosUI

struct HostProfileView: View {
    @Bindable var host: Attendee
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        Form {
            Section{
                HStack(spacing:20){
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                                if let avatarData = host.avatar, let image =
                                    UIImage(data: avatarData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } else{
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                }
                            }
                            .buttonStyle(.borderless)
                            .onChange(of: selectedItem) {_, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type:Data.self){
                                        host.avatar = data
                                    }
                                }
                            }
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("First Name", text: $host.firstName)
                            .font(.headline)
                        TextField("lastName", text: $host.lastName)
                            .font(.subheadline)
                        
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
//#Preview {
//    HostProfileView()
//}
