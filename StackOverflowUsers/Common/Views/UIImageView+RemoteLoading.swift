import UIKit

extension UIImageView {
    func load(url: URL?) {
        guard let url else {
            // In real life would load a placeholder
            // image here.
            return
        }

        // In real life we would also want to cache these images
        // so we're not remote loading them every time.
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
