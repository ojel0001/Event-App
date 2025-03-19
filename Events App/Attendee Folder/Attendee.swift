//
//  Attendee.swift
//  Events App
//
//  Created by sunny ojelabi on 2025-03-19.
//

import Foundation
import SwiftUI
import SwiftData

import SwiftData

@Model
class Attendee {
    @Attribute(.unique) var id: UUID
    var firstName: String
    var lastName: String
    var avatar: Data?
    var isHost: Bool
    
    init(id: UUID = UUID(),
         firstName: String,
         lastName: String,
         avatar: Data? = nil,
         isHost: Bool = false) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
        self.isHost = isHost
    }
}
