@testable import StackOverflowUsers

final class SpyStore: Store {

    var invokedArray = false
    var invokedArrayCount = 0
    var invokedArrayParameters: (defaultName: String, Void)?
    var invokedArrayParametersList = [(defaultName: String, Void)]()
    var stubbedArrayResult: [Any]!

    func array(forKey defaultName: String) -> [Any]? {
        invokedArray = true
        invokedArrayCount += 1
        invokedArrayParameters = (defaultName, ())
        invokedArrayParametersList.append((defaultName, ()))
        return stubbedArrayResult
    }

    var invokedSet = false
    var invokedSetCount = 0
    var invokedSetParameters: (value: Any?, defaultName: String)?
    var invokedSetParametersList = [(value: Any?, defaultName: String)]()

    func set(_ value: Any?, forKey defaultName: String) {
        invokedSet = true
        invokedSetCount += 1
        invokedSetParameters = (value, defaultName)
        invokedSetParametersList.append((value, defaultName))
    }
}
