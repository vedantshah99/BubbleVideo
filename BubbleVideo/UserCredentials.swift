//
//  UserCredentials.swift
//  BubbleVideo
//
//  Created by Vedant Shah on 9/9/24.
//

import Foundation
import StreamVideo

struct UserCredentials {
    let user: User
    let token: UserToken
}

extension UserCredentials {
    static let demoUser = UserCredentials(
        user: User(
            id: "vedantShah",
            name: "Vedant",
            imageURL: URL(string: "https://getstream.io/static/2796a305dd07651fcceb4721a94f4505/a3911/martin-mitrevski.webp"),
            customData: [:]
        ),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidmVkYW50U2hhaCJ9.ibozeDi7W4QOgkIQpOtaEgB2MmXIdODFgcOe6PW4L3c")
    )
}
