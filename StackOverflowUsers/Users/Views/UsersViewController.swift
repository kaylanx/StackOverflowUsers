import UIKit

final class UsersViewController: UIViewController {

    private enum Constants {
        static let refreshActionIdentifier = UIAction.Identifier(rawValue: "refreshAction")
        static let estimatedSectionHeaderHeight: CGFloat = 36
        static let estimatedRowHeight: CGFloat = 80
        static let sectionHeaderHeight: CGFloat = 36
    }

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let errorView = {
        let emptyStateView = EmptyStateView(frame: .zero)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        return emptyStateView
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
        layout()
        bindViewModel()
        refreshData()
    }

    private func layout() {
        addErrorView()
        addTableView()
        addLoadingView()
    }

    private func addErrorView() {
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
        tableView.refreshControl?.endRefreshing()
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
        title = viewModel.screenTitle

        viewModel.onUsersFetched = { [weak self] in
            self?.hideErrorState()
            self?.showLoadingSpinner(isLoading: false)
            self?.tableView.reloadData()
        }
        viewModel.onError = { [weak self] errorTitle, errorMessage, buttonTitle in
            self?.showErrorState(
                title: errorTitle,
                message: errorMessage,
                buttonTitle: buttonTitle
            )
        }
    }

    private func showLoadingSpinner(isLoading: Bool) {
        if isLoading {
            errorView.isHidden = true
            loadingView.startAnimating()
            tableView.isHidden = true
        } else {
            loadingView.stopAnimating()
        }
    }

    private func showErrorState(
        title: String,
        message: String,
        buttonTitle: String
    ) {
        showLoadingSpinner(isLoading: false)
        errorView.configure(
            title: title,
            message: message,
            buttonTitle: buttonTitle
        ) { [weak self] in
            self?.refreshData()
        }
        errorView.isHidden = false
    }

    private func hideErrorState() {
        errorView.isHidden = true
        tableView.isHidden = false
    }
}

// MARK: - UITableViewDataSource/Delegate

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
