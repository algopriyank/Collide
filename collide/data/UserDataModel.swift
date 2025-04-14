import Foundation
import SwiftUI

// MARK: - User Model
struct UserModel: Codable, Identifiable {
    let id: Int
    let name: String
    let avatar: String? // Profile picture URL
    let age: Int
    let gender: String
    let bio: String?
    let college: String
    let lastActive: String? // renamed to camelCase
    let verified: Bool
    
    var photos: [Photo]?
    var interests: [Interest]?
    var swipeHistory: [Swipe]?
    var matches: [Match]?
    var reviews: [Review]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, avatar, age, gender, bio, college, verified
        case lastActive = "last_active"
        case photos, interests, swipeHistory, matches, reviews
    }
}

// MARK: - Photo
struct Photo: Codable, Identifiable {
    let id: Int
    let userId: Int
    let photoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case photoUrl = "photo_url"
    }
}

// MARK: - Interest
struct Interest: Codable, Identifiable {
    let id: String
    let name: String
}

// MARK: - Swipe
struct Swipe: Codable, Identifiable {
    let id: String
    let swiperId: String
    let swipeeId: String
    let direction: String
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case swiperId = "swiper_id"
        case swipeeId = "swipee_id"
        case direction
        case timestamp
    }
}

// MARK: - Match
struct Match: Codable, Identifiable {
    let id: String
    let user1Id: Int
    let user2Id: Int
    let matchedOn: String
    let user1: UserModel
    let user2: UserModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case user1Id = "user1_id"
        case user2Id = "user2_id"
        case matchedOn = "matched_on"
        case user1
        case user2
    }
}
// MARK: - Review
struct Review: Codable, Identifiable {
    let id: String
    let reviewerId: String
    let reviewedId: String
    let reviewText: String?
    let rating: Int?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case reviewerId = "reviewer_id"
        case reviewedId = "reviewed_id"
        case reviewText = "review_text"
        case rating
        case createdAt = "created_at"
    }
}
