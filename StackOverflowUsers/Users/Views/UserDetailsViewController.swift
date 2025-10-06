//
//  UserDetailsViewController.swift
//  StackOverflowUsers
//
//  Created by Andy Kayley on 02/10/2025.
//

import UIKit

final class UserDetailsViewController: UIViewController {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Doe"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private let reputationLabel: UILabel = {
        let label = UILabel()
        label.text = "Reputation: 1234"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "https://example.com"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemBlue
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "San Francisco, CA"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.configuration = .prominentGlass()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var viewModel: UserViewModel

    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindViewModel()
    }

    private func bindViewModel() {
        profileImageView.load(url: viewModel.profileImageURL)
        nameLabel.text = viewModel.name
        reputationLabel.text = "\(viewModel.reputation)"
        locationLabel.text = viewModel.location
        websiteLabel.text = viewModel.websiteURL

        followButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        updateFollowButton()
    }

    private func updateFollowButton() {
        followButton.setImage(
            UIImage(systemName: viewModel.followButtonImageName),
            for: .normal
        )
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }

    @objc private func didTapButton() {
        viewModel.toggleFollow()
        updateFollowButton()
    }

    private func setupLayout() {
        // Vertical stack for labels
        let infoStack = UIStackView(
            arrangedSubviews: [
                nameLabel,
                reputationLabel,
                websiteLabel,
                locationLabel,
                followButton
            ]
        )
        infoStack.axis = .vertical
        infoStack.alignment = .leading
        infoStack.spacing = 8

        // Main vertical stack: image on top, then labels
        let mainStack = UIStackView(arrangedSubviews: [profileImageView, infoStack])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120)
        ])

        profileImageView.layer.cornerRadius = 60
    }
}
