import Foundation

final class FollowStorage: FollowStore {
    private let key = "followedUsers"

    private let store: Store

    init(store: Store = UserDefaults.standard) {
        self.store = store
    }

    private var followedUsers: Set<Int> {
        get {
            let ids = store.array(forKey: key) as? [Int] ?? []
            return Set(ids)
        }
        set {
            store.set(Array(newValue), forKey: key)
        }
    }

    func isFollowed(userId: Int) -> Bool {
        followedUsers.contains(userId)
    }

    func follow(userId: Int) {
        var users = followedUsers
        users.insert(userId)
        followedUsers = users
    }

    func unfollow(userId: Int) {
        var users = followedUsers
        users.remove(userId)
        followedUsers = users
    }
}
