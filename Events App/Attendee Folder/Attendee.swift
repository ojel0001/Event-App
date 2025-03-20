//
//  Attendee.swift
//  Events App
//
//

import Foundation
import SwiftUI
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
