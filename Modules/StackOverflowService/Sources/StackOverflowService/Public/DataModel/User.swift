import Foundation

// Optionality added according to the documentation:
// https://api.stackexchange.com/docs/types/user
public struct User: Decodable, Sendable, Equatable {

    public struct BadgeCounts: Decodable, Sendable, Equatable {
        let bronze: Int
        let silver: Int
        let gold: Int
    }

    public enum UserType: String, Decodable, Sendable, Equatable {
        case unregistered
        case registered
        case moderator
        case teamAdmin
        case doesNotExist
    }

    public let badgeCounts: BadgeCounts
    public let accountId: Int
    public let isEmployee: Bool
    public let lastModifiedDate: Date?
    public let lastAccessDate: Date
    public let reputationChangeYear: Int
    public let reputationChangeQuarter: Int
    public let reputationChangeMonth: Int
    public let reputationChangeWeek: Int
    public let reputationChangeDay: Int
    public let reputation: Int
    public let creationDate: Date
    public let userType: UserType
    public let userId: Int
    public let acceptRate: Int?
    public let aboutMe: String?
    public let location: String?
    public let websiteUrl: String?
    public let link: String
    public let profileImage: String
    public let displayName: String
    public let timedPenaltyDate: Date?
    public let age: Int?
}
