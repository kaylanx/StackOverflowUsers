@testable import StackOverflowUsers

final class SpyFollowStore: FollowStore {

    var invokedIsFollowed = false
    var invokedIsFollowedCount = 0
    var invokedIsFollowedParameters: (userId: Int, Void)?
    var invokedIsFollowedParametersList = [(userId: Int, Void)]()
    var stubbedIsFollowedResult: [Int: Bool] = [:]

    func isFollowed(userId: Int) -> Bool {
        invokedIsFollowed = true
        invokedIsFollowedCount += 1
        invokedIsFollowedParameters = (userId, ())
        invokedIsFollowedParametersList.append((userId, ()))
        return stubbedIsFollowedResult[userId] ?? false
    }

    var invokedFollow = false
    var invokedFollowCount = 0
    var invokedFollowParameters: (userId: Int, Void)?
    var invokedFollowParametersList = [(userId: Int, Void)]()

    func follow(userId: Int) {
        invokedFollow = true
        invokedFollowCount += 1
        invokedFollowParameters = (userId, ())
        invokedFollowParametersList.append((userId, ()))
        stubbedIsFollowedResult[userId] = true
    }

    var invokedUnfollow = false
    var invokedUnfollowCount = 0
    var invokedUnfollowParameters: (userId: Int, Void)?
    var invokedUnfollowParametersList = [(userId: Int, Void)]()

    func unfollow(userId: Int) {
        invokedUnfollow = true
        invokedUnfollowCount += 1
        invokedUnfollowParameters = (userId, ())
        invokedUnfollowParametersList.append((userId, ()))
        stubbedIsFollowedResult[userId] = false
    }
}
