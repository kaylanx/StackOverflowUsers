# StackOverflow Users Service

This Swift package provides a simple way to fetch StackOverflow users using a network client.

## ✨ Overview

The package exposes the following public components:

### ServiceFactory
```swift
public enum ServiceFactory {
    public static func userService(
        networkClient: NetworkClient,
        baseURL: URL
    ) -> UserService
}
```
Creates a `UserService` instance using the given `NetworkClient` and `baseURL`.

### UserService
```swift
public protocol UserService {
    func fetchUsers() async throws -> [User]
}
```
Protocol defining a service that fetches users asynchronously.

### UserServiceError
```swift
public enum UserServiceError: Error {
    case invalidResponse
}
```
Error type for `UserService` operations.

### User
```swift
public struct User: Decodable, Sendable, Equatable {

    public struct BadgeCounts: Decodable, Sendable, Equatable {
        let bronze: Int
        let silver: Int
        let gold: Int
    }

    public enum UserType: String, Decodable, Sendable, Equatable {
        case unregistered
        case registered
        case moderator
        case teamAdmin
        case doesNotExist
    }

    public let badgeCounts: BadgeCounts
    public let accountId: Int
    public let isEmployee: Bool
    public let lastModifiedDate: Date?
    public let lastAccessDate: Date
    public let reputationChangeYear: Int
    public let reputationChangeQuarter: Int
    public let reputationChangeMonth: Int
    public let reputationChangeWeek: Int
    public let reputationChangeDay: Int
    public let reputation: Int
    public let creationDate: Date
    public let userType: UserType
    public let userId: Int
    public let acceptRate: Int?
    public let aboutMe: String?
    public let location: String?
    public let websiteUrl: String?
    public let link: String
    public let profileImage: String
    public let displayName: String
    public let timedPenaltyDate: Date?
    public let age: Int?
}
```

## 🚀 Usage

1. Create a `NetworkClient` instance (for example, using `NetworkClientFactory` from your networking layer).
2. Use `ServiceFactory.userService(networkClient:baseURL:)` to create a `UserService`.
3. Call `fetchUsers()` to retrieve an array of `User`.

## Example

```swift
let networkClient = NetworkClientFactory.networkClient()
let baseURL = URL(string: "https://api.stackexchange.com/2.3")!
let userService = ServiceFactory.userService(networkClient: networkClient, baseURL: baseURL)

Task {
    do {
        let users = try await userService.fetchUsers()
        print("Fetched users: \(users)")
    } catch {
        print("Failed to fetch users: \(error)")
    }
}
```
