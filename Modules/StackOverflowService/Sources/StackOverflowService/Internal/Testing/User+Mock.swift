import Foundation

extension User {
    static let mock = User(
        badgeCounts: BadgeCounts(bronze: 123, silver: 456, gold: 789),
        accountId: 123,
        isEmployee: false,
        lastModifiedDate: ISO8601DateFormatter().date(from: "2025-09-11T12:00:00Z")!,
        lastAccessDate: ISO8601DateFormatter().date(from: "2025-09-11T12:30:00Z")!,
        reputationChangeYear: 3,
        reputationChangeQuarter: 4,
        reputationChangeMonth: 5,
        reputationChangeWeek: 6,
        reputationChangeDay: 7,
        reputation: 44,
        creationDate: ISO8601DateFormatter().date(from: "2007-03-26T15:41:57Z")!,
        userType: .registered,
        userId: 1,
        acceptRate: 3,
        aboutMe: "aboutMe",
        location: "location",
        websiteUrl: "websiteUrl",
        link: "link",
        profileImage: "https://example.com/image.png",
        displayName: "displayName",
        timedPenaltyDate: nil,
        age: nil
    )
}
