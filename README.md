# 📱 StackOverflow Users App

A simple iOS app built with UIKit and Swift Concurrency that displays
the **Top 20 Stack Overflow users** by reputation.\
Users can **follow/unfollow** people locally, view their profile
pictures, reputation, and display names.

------------------------------------------------------------------------

## 🚀 Features

-   Fetches user data from the [Stack Exchange
    API](https://api.stackexchange.com/2.3/users).
-   Displays each user's **name**, **profile image**, and **reputation**
    in a clean table view.
-   Includes a **Follow** button to locally track followed users (stored
    using `UserDefaults`).
-   Supports **pull-to-refresh**.
-   Handles loading and error states with a **reusable empty/error
    view**.
-   Built using **MVVM** with a **Use Case** layer for clear separation
    of concerns.

------------------------------------------------------------------------

## 🛠 Installation Requirements

-   **Xcode 26** or newer.
-   iOS **26.0** deployment target (adjust in the project settings if
    needed).
-   Swift **6.0** or newer.
-   No third-party dependencies - pure UIKit and Foundation.

------------------------------------------------------------------------

## 📦 Getting Started

1.  Clone the repository:

    ``` bash
    git clone https://github.com/kaylanx/StackOverflowUsers.git
    ```

2.  Open the project in **Xcode 26**:

    ``` bash
    open StackOverflowUsersApp.xcodeproj
    ```

3.  Build and run on the simulator or a physical device.

------------------------------------------------------------------------

## 🧩 Technical Decisions

### Architecture

-   **MVVM + Use Case**:
    -   `UsersViewModel` handles state for the UI.
    -   `DefaultUsersUseCase` handles business logic, fetching and
        mapping users, and follow/unfollow actions.
    -   `FollowStore` abstracts local persistence (currently
        `UserDefaults` for simplicity).
    -   Networking and mapping are isolated in the
        **StackOverflowService** Swift Package for reusability and
        testing.

### Networking

-   **`NetworkClient` Protocol + Default Implementation**:
    -   Uses `URLSession` with `async/await`.
    -   Errors are mapped to a small `UserServiceError` enum for
        clarity.

### Persistence

-   **`FollowStore`**:
    -   Implemented with `UserDefaults` to meet the tech test's
        simplicity requirements.
    -   Can easily be swapped with a database or cloud sync solution
        later.

### Error & Loading States

-   Custom `EmptyStateView` is reusable across screens for showing
    errors or empty content.
-   Displays a retry button to re-fetch users without restarting the
    app.

### UI

-   **UITableView** with dynamic cell heights.
-   Uses `UserTableViewCell` to display user info and a **Follow**
    button.

------------------------------------------------------------------------

## 🧪 Testing

-   Uses **Swift Testing** (not XCTest) for modern test syntax.\
-   Includes:
    -   Unit tests for `UsersViewModel`.\
    -   Unit tests for `DefaultUsersUseCase`.\
    -   Tests for mapping network responses to models.\
    -   Tests for toggling follow state.

Run tests in Xcode with **Product → Test** or `Cmd+U`.

------------------------------------------------------------------------
