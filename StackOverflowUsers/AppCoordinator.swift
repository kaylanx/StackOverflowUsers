//
//  AppCoordinator.swift
//  StackOverflowUsers
//
//  Created by Andy Kayley on 10/09/2025.
//

import UIKit
import Networking
import StackOverflowService

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

        let usersViewModel = UsersViewModel(usersUseCase: usersUseCase)
        let viewController = UsersViewController(viewModel: usersViewModel)
        let navigation = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
}
