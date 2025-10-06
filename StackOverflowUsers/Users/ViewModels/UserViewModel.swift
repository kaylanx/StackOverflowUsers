import Foundation

struct UserViewModel: Equatable {
    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        lhs.id == rhs.id
    }

    enum ImageNames {
        static let followButtonImageName = "person"
        static let unfollowButtonImageName = "person.fill.checkmark"
    }

    let id: Int
    let name: String
    let reputation: Int
    let profileImageURL: URL?
    let location: String?
    let websiteURL: String?

    var followed: Bool
    var followButtonImageName: String {
        followed ? ImageNames.unfollowButtonImageName : ImageNames.followButtonImageName
    }

    var followButtonText: String {
        followed ? "Following" : "Follow"
    }

    private let onToggleFollow: (UserViewModel) -> Bool

    init(
        id: Int,
        name: String,
        reputation: Int,
        profileImageURL: URL?,
        location: String?,
        websiteURL: String?,
        followed: Bool,
        onToggleFollow: @escaping (UserViewModel) -> Bool
    ) {
        self.id = id
        self.name = name
        self.reputation = reputation
        self.profileImageURL = profileImageURL
        self.location = location
        self.websiteURL = websiteURL
        self.followed = followed
        self.onToggleFollow = onToggleFollow
    }

    mutating func toggleFollow() {
        followed = onToggleFollow(self)
    }
}
