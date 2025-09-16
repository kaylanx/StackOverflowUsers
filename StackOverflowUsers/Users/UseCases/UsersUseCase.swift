protocol UsersUseCase {
    func users() async throws -> [UserViewModel]
    func toggleFollowing(of user: UserViewModel)
    func following(user: UserViewModel) -> Bool
}
