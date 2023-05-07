//
//  TransactionViewController.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import UIKit

final class TranscationViewController: UIViewController {
    private let tableView = UITableView()

    private lazy var tableViewDataSource = makeDataSource()

    private var model: TransactionModelProtocol

    init(model: TransactionModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        loadTransactions()
    }

    private func loadTransactions() {
        model.getTransactionsByProduct { [weak self] result in
            switch result {
            case .success(let data):
                self?.render(with: data)
            case .failure(let failure):
                print(failure)
                // TODO: alert
            }
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = makeDataSource()
        tableView.backgroundColor = .white
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
    }

    private func render(with transactions: [TransactionDisplayData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TransactionDisplayData>()

        snapshot.appendSections([0])
        snapshot.appendItems(transactions, toSection: 0)
        tableViewDataSource.applySnapshotUsingReloadData(snapshot)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, TransactionDisplayData> {
        let tableViewDataSource = UITableViewDiffableDataSource<Int, TransactionDisplayData>(tableView: tableView) { tableView, indexPath, product in
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
            cell.configure(with: product)
            return cell
        }
        return tableViewDataSource
    }
}

extension TranscationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  HeaderView()
        headerView.configure(with: model.totalSum)
        return headerView
    }
}
