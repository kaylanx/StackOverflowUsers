import Foundation

protocol Store {
    func array(forKey defaultName: String) -> [Any]?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: Store { }
