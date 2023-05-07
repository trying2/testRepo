//
//  TransactionModel.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import Foundation

struct TransactionDisplayData: Hashable {
    let id: UUID = .init()
    let currentCurrencySymbol: String
    let currentCurrencyAmount: String
    let gbpCurrencyAmount: String
}

protocol TransactionModelProtocol {
    var totalSum: String { get }
    func getTransactionsByProduct(completion: @escaping (Result<[TransactionDisplayData], Error>) -> Void)
}

final class TransactionModel: TransactionModelProtocol {
    private let fileService: FileDataServiceProtocol
    private let skuName: String
    var totalSum: String

    init(fileService: FileDataServiceProtocol, skuName: String) {
        self.fileService = fileService
        self.skuName = skuName
        self.totalSum = ""
    }

    func getTransactionsByProduct(completion: @escaping (Result<[TransactionDisplayData], Error>) -> Void) {
        fileService.getTransactionsByProduct(with: skuName) { [weak self] result in
            switch result {
            case .success(let data):
                self?.totalSum = String(format: "%.2f", data.compactMap { Double($0.gbpCurrencyAmount) }.reduce(0, +))
                completion(.success(data))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
