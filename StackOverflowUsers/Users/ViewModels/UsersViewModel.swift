import Foundation
import StackOverflowService

final class UsersViewModel {

    enum Strings {
        // These would come from Localizable.strings...
        static let errorMessageTitle = "Something went wrong"
        static let errorFetchingUsers = "There was a problem fetching the users. Please try again."
        static let errorMessageButtonTitle = "Retry"
        static let screenTitle = "Top 20 StackOverflow Users"
    }

    private(set) var users: [UserViewModel] = []

    var onUsersFetched: (() -> Void)?
    var onUserUpdated: ((_ userIndex: Int) -> Void)?
    var onError: ((_ title: String, _ errorMessage: String, _ buttonTitle: String) -> Void)?

    let screenTitle: String = Strings.screenTitle

    private let usersUseCase: UsersUseCase
    var loadDataTask: Task<Void, Never>?

    private weak var userSelectedDelegate: UserSelectedDelegate?

    init(
        usersUseCase: UsersUseCase,
        userSelectedDelegate: UserSelectedDelegate?
    ) {
        self.usersUseCase = usersUseCase
        self.userSelectedDelegate = userSelectedDelegate
    }

    func loadData() {
        loadDataTask?.cancel()
        loadDataTask = Task {
            defer { loadDataTask = nil }
            do {
                users = try await usersUseCase.users()
                await MainActor.run {
                    onUsersFetched?()
                }
            } catch is CancellationError {
                // Ignore task cancellations.
            } catch {
                await MainActor.run {
                    onError?(
                        Strings.errorMessageTitle,
                        Strings.errorFetchingUsers,
                        Strings.errorMessageButtonTitle
                    )
                }
            }
        }
    }

    func toggleFollowing(of user: UserViewModel) {
        usersUseCase.toggleFollowing(of: user)
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            var userToUpdate = users[index]
            userToUpdate.followed = usersUseCase.following(user: user)
            users[index] = userToUpdate
            
            onUserUpdated?(index)
        }
    }

    func tapped(user: UserViewModel) {
        userSelectedDelegate?.didSelectUser(user)
    }
}
