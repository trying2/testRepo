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
    func getTransactionsByProduct(completion: @escaping (Result<[TransactionDisplayData], Error>) -> Void)
}

final class TransactionModel: TransactionModelProtocol {
    private let fileService: FileDataServiceProtocol
    private let skuName: String

    init(fileService: FileDataServiceProtocol, skuName: String) {
        self.fileService = fileService
        self.skuName = skuName
    }

    func getTransactionsByProduct(completion: @escaping (Result<[TransactionDisplayData], Error>) -> Void) {
        fileService.getTransactionsByProduct(with: skuName, completion: completion)
    }
}
