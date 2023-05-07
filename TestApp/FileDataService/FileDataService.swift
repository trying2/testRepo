//
//  FileDataService.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//


protocol FileDataServiceProtocol {
    func getProductList(completion: @escaping (Result<[Product], Error>) -> Void)
    func getTransactionsByProduct(with sku: String, completion: @escaping (Result<[TransactionDisplayData], Error>) -> Void)
}

final class FileDataService: FileDataServiceProtocol {
    private let fileDataManager: FileDataManagerProtocol

    init(FileDataManager: FileDataManagerProtocol) {
        self.fileDataManager = FileDataManager
    }

    func getProductList(completion: @escaping (Result<[Product], Error>) -> Void) {
        fileDataManager.getProductsList { result in
            switch result {
            case .success(let productList):
                let products = productList.map { Product(name: $0.key, transactionCount: $0.value) }
                completion(.success(products))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }

    private func mapToDisplayDataTransaction(from data: TransactionData) -> TransactionDisplayData? {
        guard let rates = try? fileDataManager.readDataFromRatesPlist() else { return nil }
        let dtoRates = rates.map { CurrencyRateDTO(from: $0) }
        let dtoTransaction = TransactionDataDTO(from: data)
        if data.currency != "GBP" {
            let symbol = CurrencySymbol(rawValue: data.currency.lowercased())?.symbol() ?? ""
            let convertedRate = convertToGBP(transaction: dtoTransaction, rates: dtoRates) ?? 0
            return TransactionDisplayData(currentCurrencySymbol: symbol, currentCurrencyAmount: data.amount, gbpCurrencyAmount: String(format: "%.2f", convertedRate))
        } else {
            return TransactionDisplayData(currentCurrencySymbol: "£", currentCurrencyAmount: data.amount, gbpCurrencyAmount: data.amount)
        }
    }

    func getTransactionsByProduct(with sku: String, completion: @escaping (Result<[TransactionDisplayData], Error>) -> Void) {
        fileDataManager.getTransactionsByProduct(with: sku) { result in
            switch result {
            case .success(let transactionList):
                guard let transactionList else {
                    completion(.success([TransactionDisplayData]()))
                    return
                }
                let displayData = transactionList.compactMap { self.mapToDisplayDataTransaction(from: $0) }
                completion(.success(displayData))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }

    private func convertToGBP(transaction: TransactionDataDTO, rates: [CurrencyRateDTO]) -> Double? {
        let directConversions = rates.filter { $0.from == transaction.currency && $0.to == "GBP" }

        if let directConversion = directConversions.first {
            return transaction.amount * directConversion.rate
        }
        let possibleConversions = rates.filter { $0.from == transaction.currency }
        for conversion in possibleConversions {
            if let rate = convertToGBP(transaction: TransactionDataDTO(amount: transaction.amount * conversion.rate, currency: conversion.to), rates: rates) {
                return rate
            }
        }
        return 0
    }
}
