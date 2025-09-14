import UIKit

final class UsersViewController: UIViewController {

    private enum Constants {
        static let refreshActionIdentifier = UIAction.Identifier(rawValue: "refreshAction")
        static let estimatedSectionHeaderHeight: CGFloat = 36
        static let estimatedRowHeight: CGFloat = 80
        static let sectionHeaderHeight: CGFloat = 36
    }

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let viewModel: UsersViewModel

    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = viewModel.screenTitle
        layout()
        bindViewModel()
        showLoadingSpinner(isLoading: true)
        viewModel.loadData()
    }

    private func layout() {
        addTableView()
        addLoadingView()
    }

    private func addTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableView.refreshControl = UIRefreshControl()
        let refreshAction = UIAction(
            identifier: Constants.refreshActionIdentifier
        ) { [weak self] _ in
            self?.refreshData()
        }
        tableView.refreshControl?.addAction(refreshAction, for: .valueChanged)
        setupTableView()
    }

    private func addLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func refreshData() {
        showLoadingSpinner(isLoading: true)
        viewModel.loadData()
        self.tableView.refreshControl?.endRefreshing()
    }

    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = Constants.estimatedSectionHeaderHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
    }

    private func bindViewModel() {
        viewModel.onUsersFetched = { [weak self] in
            self?.showLoadingSpinner(isLoading: false)
            self?.tableView.reloadData()
        }
        viewModel.onError = { [weak self] errorTitle, errorMessage, buttonTitle in
            self?.presentAlert(
                title: errorTitle,
                message: errorMessage,
                buttonTitle: buttonTitle
            )
        }
    }

    private func showLoadingSpinner(isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.loadingView.startAnimating()
                self?.tableView.isHidden = true
            } else {
                self?.loadingView.stopAnimating()
                self?.tableView.isHidden = false
            }
        }
    }
}

// MARK: - UITableViewDataSource/Delegate

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable default cell
        let user = viewModel.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        if let cell = cell as? UserTableViewCell {
            cell.configure(
                name: user.name,
                reputation: "▲ \(user.reputation)",
                profileImageURL: user.profileImageURL
            )
        }

        return cell
    }
}

// MARK: Alert Presenting
extension UsersViewController {

    private func presentAlert(
        title: String,
        message: String,
        buttonTitle: String
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(
                title: buttonTitle,
                style: .default
            )
        )
        self.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
}
