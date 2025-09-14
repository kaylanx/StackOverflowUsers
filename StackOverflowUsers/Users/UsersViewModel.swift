import Foundation
import StackOverflowService

final class UsersViewModel {

    enum Strings {
        // These would come from Localizable.strings...
        static let errorMessageTitle = "Something went wrong"
        static let errorFetchingUsers = "There was a problem fetching the users. Please try again."
        static let errorMessageButtonTitle = "OK"
        static let screenTitle = "Top 20 StackOverflow Users"
    }

    private(set) var users: [UserViewModel] = []

    var onUsersFetched: (() -> Void)?
    var onError: ((_ title: String, _ errorMessage: String, _ buttonTitle: String) -> Void)?

    let screenTitle: String = Strings.screenTitle

    private let userService: UserService
    var loadDataTask: Task<Void, Never>?

    init(userService: UserService) {
        self.userService = userService
    }

    func loadData() {
        loadDataTask?.cancel()
        loadDataTask = Task {
            defer { loadDataTask = nil }
            do {
                users = try await userService.fetchUsers().compactMap {
                    UserViewModel(
                        id: $0.userId,
                        name: $0.displayName,
                        reputation: $0.reputation,
                        profileImageURL: URL(string: $0.profileImage)
                    )
                }
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
}
