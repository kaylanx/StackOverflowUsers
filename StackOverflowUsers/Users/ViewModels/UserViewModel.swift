import Foundation

final class UserViewModel {

    enum ImageNames {
        static let followButtonImageName = "person"
        static let unfollowButtonImageName = "person.fill.checkmark"
    }

    let id: Int
    let name: String
    let reputation: Int
    let profileImageURL: URL?
    var followed: Bool
    var followButtonImageName: String {
        followed ? ImageNames.unfollowButtonImageName : ImageNames.followButtonImageName
    }

    init(
        id: Int,
        name: String,
        reputation: Int,
        profileImageURL: URL?,
        followed: Bool
    ) {
        self.id = id
        self.name = name
        self.reputation = reputation
        self.profileImageURL = profileImageURL
        self.followed = followed
    }
}
