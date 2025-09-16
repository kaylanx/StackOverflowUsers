import Foundation
import StackOverflowService

final class DefaultUsersUseCase: UsersUseCase {
    private let userService: UserService
    private let followStore: FollowStore

    init(
        userService: UserService,
        followStore: FollowStore
    ) {
        self.userService = userService
        self.followStore = followStore
    }

    func toggleFollowing(of user: UserViewModel) {
        user.followed.toggle()
        if followStore.isFollowed(userId: user.id) {
            followStore.unfollow(userId: user.id)
        } else {
            followStore.follow(userId: user.id)
        }
    }

    func users() async throws -> [UserViewModel] {
        try await userService.fetchUsers().map {
            UserViewModel(
                id: $0.userId,
                name: $0.displayName.htmlDecoded,
                reputation: $0.reputation,
                profileImageURL: URL(string: $0.profileImage),
                followed: followStore.isFollowed(userId: $0.userId)
            )
        }
    }
}
