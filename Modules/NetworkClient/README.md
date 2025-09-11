# 📡 NetworkClient

A lightweight, async/await–based networking utility for Swift.  
This package provides a clean abstraction over `URLSession.data(for:)`,  
with strong typing, error handling, and easy testability.

---

## ✨ Features
- ✅ **Async/Await Support** — Built on `try await URLSession.data(for:)`.  
- ✅ **Type-Safe Decoding** — Decodes JSON directly into your models.  
- ✅ **Centralized Error Handling** — `NetworkError` for invalid responses, HTTP errors, and decoding failures.  
- ✅ **Test-Friendly Design** — `NetworkClient` is a protocol, making mocking simple.  
- ✅ **Factory Method** — `NetworkClientFactory` provides a ready-to-use default client.

---

## 📦 Installation

### Swift Package Manager  
Add this package as a local or remote dependency in **Xcode** or your `Package.swift`:  
```swift
dependencies: [
    .package(path: "../NetworkClient") // Local package
    // or .package(url: "https://github.com/yourusername/NetworkClient.git", from: "1.0.0")
]
```
Then add `NetworkClient` to your target’s dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: ["NetworkClient"]
)
```

## 🚀 Usage
1. Create a URLRequest

```swift
let url = URL(string: "https://api.example.com/user/1")!
let request = URLRequest(url: url)
```

2. Fetch and Decode

```swift
struct User: Decodable {
    let id: Int
    let name: String
}

let client = NetworkClientFactory.networkClient()

do {
    let user: User = try await client.fetch(request, as: User.self)
    print("Fetched user:", user)
} catch {
    print("Network error:", error)
}

```

## 🧪 Testing
You can create a mock implementation of `NetworkClient` or
use a custom `URLProtocol` to intercept network calls during tests.
This makes it easy to verify error handling (e.g., invalid responses)
without hitting real network endpoints.

