import UIKit

final class EmptyStateView: UIView {

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .prominentGlass()
        return button
    }()

    // MARK: - Callback
    private var buttonAction: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Configuration
    func configure(
        title: String,
        message: String,
        buttonTitle: String,
        buttonAction: @escaping () -> Void
    ) {
        titleLabel.text = title
        messageLabel.text = message
        actionButton.setTitle(buttonTitle, for: .normal)
        self.buttonAction = buttonAction
    }


    // MARK: - Setup
    private func setupView() {
        isHidden = true

        let vStack = UIStackView(
            arrangedSubviews: [titleLabel, messageLabel, actionButton]
        )
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .center

        addSubview(vStack)

        actionButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }

    @objc private func didTapRetry() {
        buttonAction?()
    }
}
