//
//  AppCoordinator.swift
//  StackOverflowUsers
//
//  Created by Andy Kayley on 10/09/2025.
//

import UIKit
import Networking
import StackOverflowService

protocol UserSelectedDelegate: AnyObject {
    func didSelectUser(_ user: UserViewModel)
}

final class AppCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let networkClient = NetworkClientFactory.networkClient(
            keyDecodingStrategy: .convertFromSnakeCase,
            dateDecodingStrategy: .secondsSince1970
        )

        let userService = ServiceFactory.userService(
            networkClient: networkClient,
            baseURL: URL(string: "https://api.stackexchange.com/2.3")!
        )

        let followStore = FollowStorage(store: UserDefaults.standard)
        let usersUseCase = DefaultUsersUseCase(
            userService: userService,
            followStore: followStore
        )

        let usersViewModel = UsersViewModel(usersUseCase: usersUseCase, userSelectedDelegate: self)
        let viewController = UsersViewController(viewModel: usersViewModel)
        let navigation = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: UserSelectedDelegate {
    func didSelectUser(_ user: UserViewModel) {
        print("User selected: \(user)")

        let userDetailViewController = UserDetailsViewController(
            viewModel: user
        )

        let navigationController = window.rootViewController as? UINavigationController
        navigationController?.pushViewController(userDetailViewController, animated: true)
    }
}
