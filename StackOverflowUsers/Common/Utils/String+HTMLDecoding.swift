import UIKit

extension String {
    var htmlDecoded: String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let decoded = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return decoded.string
        }
        return self
    }
}
