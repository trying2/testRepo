//
//  ProductsModel.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import UIKit

protocol ProductsModelProtocol {
    func getProductList(completion: @escaping (Result<[Product], Error>) -> Void)
    func goToTransactionScreen(_ navigationController: UINavigationController?, with product: Product)
}

final class ProductsModel: ProductsModelProtocol {
    private let fileService: FileDataServiceProtocol

    init(fileService: FileDataServiceProtocol) {
        self.fileService = fileService
    }

    func getProductList(completion: @escaping (Result<[Product], Error>) -> Void) {
        fileService.getProductList(completion: completion)
    }

    func goToTransactionScreen(_ navigationController: UINavigationController?, with product: Product) {
        let vc = TransactionScreenAssembly.build(with: product.name)
        vc.title = "Transactions for \(product.name)"
        navigationController?.pushViewController(vc, animated: true)
    }
}
