import Testing

@testable import StackOverflowUsers

struct FollowStorageTests {

    private var spyStore = SpyStore()
    private let followStorage: FollowStorage!

    init() {
        followStorage = FollowStorage(store: spyStore)
    }

    @Test("When user has not been followed, user is not followed")
    func emptyStorage() throws {
        let followed = followStorage.isFollowed(userId: 123)
        #expect(!followed)

        #expect(spyStore.invokedArray)
        let (defaultName, _) = try #require(spyStore.invokedArrayParameters)
        #expect(defaultName == "followedUsers")
    }

    @Test("When user has been followed, then store receives user")
    func followUser() throws {
        spyStore.stubbedArrayResult = []

        followStorage.follow(userId: 123)
        #expect(spyStore.invokedSet)
        let (value, defaultName) = try #require(spyStore.invokedSetParameters)

        let valueSet = try #require(value as? Array<Int>)
        #expect(valueSet.first == 123)
        #expect(defaultName == "followedUsers")
    }

    @Test("When user has been unfollowed, user is unfollowed")
    func unFollowUser() throws {
        spyStore.stubbedArrayResult = []

        followStorage.unfollow(userId: 123)
        #expect(spyStore.invokedSet)
        let (value, defaultName) = try #require(spyStore.invokedSetParameters)

        let valueSet = try #require(value as? Array<Int>)
        #expect(valueSet.isEmpty)
        #expect(defaultName == "followedUsers")
    }
}
