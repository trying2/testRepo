//
//  ViewController.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import UIKit
import SnapKit

final class ProductsViewController: UIViewController {
    private let model: ProductsModelProtocol

    private let tableView = UITableView()

    private lazy var tableViewDataSource = makeDataSource()

    init(model: ProductsModelProtocol) {
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
        getProductList()
        title = "Products"
        navigationController?.navigationBar.tintColor = .blue
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.dataSource = makeDataSource()
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
    }

    private func render(with products: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()

        snapshot.appendSections([0])
        snapshot.appendItems(products, toSection: 0)
        tableViewDataSource.applySnapshotUsingReloadData(snapshot)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, Product> {
        let tableViewDataSource = UITableViewDiffableDataSource<Int, Product>(tableView: tableView) { tableView, indexPath, product in
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
            cell.configure(with: product)
            return cell
        }
        return tableViewDataSource
    }

    private func getProductList() {
        model.getProductList { [weak self] result in
            switch result {
            case .success(let data):
                self?.render(with: data)
            case .failure(let failure):
                print(failure)
                // TODO: alert
            }
        }
    }
}

extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = tableViewDataSource.itemIdentifier(for: indexPath) else { return }
        model.goToTransactionScreen(navigationController, with: product)
    }
}

