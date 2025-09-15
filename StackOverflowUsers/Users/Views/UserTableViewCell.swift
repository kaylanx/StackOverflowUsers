import UIKit

final class UserTableViewCell: UITableViewCell {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default
            .scaledFont(for: .systemFont(ofSize: 17, weight: .semibold))
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let reputationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default
            .scaledFont(for: .systemFont(ofSize: 15, weight: .semibold))
        label.textColor = .gray
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.configuration = .prominentGlass()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Callback
    private var buttonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(reputationLabel)
        contentView.addSubview(followButton)

        followButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        // Layout constraints
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            reputationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            reputationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            reputationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.widthAnchor.constraint(equalToConstant: 80),
            followButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(
        name: String,
        reputation: String,
        profileImageURL: URL?,
        buttonSystemImageName: String,
        buttonAction: (() -> Void)?
    ) {
        nameLabel.text = name
        reputationLabel.text = reputation
        followButton.setImage(UIImage(systemName: buttonSystemImageName), for: .normal)
        profileImageView.load(url: profileImageURL)
        self.buttonAction = buttonAction
    }

    @objc private func didTapButton() {
        buttonAction?()
    }
}
