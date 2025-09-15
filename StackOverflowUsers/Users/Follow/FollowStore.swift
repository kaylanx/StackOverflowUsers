protocol FollowStore {
    func isFollowed(userId: Int) -> Bool
    func follow(userId: Int)
    func unfollow(userId: Int)
}
