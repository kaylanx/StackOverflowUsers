import Foundation

public enum StackOverflowServiceFactory {
    public static func service() -> StackOverflowService {
        DefaultStackOverflowService()
    }
}
