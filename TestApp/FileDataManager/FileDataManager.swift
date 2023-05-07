//
//  FileDataManager.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import Foundation

enum TechError: Error {
    case fileReadError
}

struct Transaction: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

struct CurrencyRate: Decodable {
    let from: String
    let rate: String
    let to: String
}

struct TransactionData {
    let amount: String
    let currency: String
}

protocol FileDataManagerProtocol {
    func readDataFromRatesPlist() throws -> [CurrencyRate]?
    func getProductsList(completion: @escaping (Result<[String: Int], Error>) -> Void)
    func getTransactionsByProduct(with sku: String, completion: @escaping (Result<[TransactionData]?, Error>) -> Void)
}

final class FileDataManager: FileDataManagerProtocol {
    static let shared = FileDataManager()
    var cachedTransactionList: [String: [TransactionData]]?

    func readDataFromRatesPlist() throws -> [CurrencyRate]? {
        guard let path = Bundle.main.path(forResource: "rates", ofType: "plist") else { return nil }

        let url = URL(fileURLWithPath: path)

        let data = try Data(contentsOf: url)

        let currencyRates = try PropertyListDecoder().decode([CurrencyRate].self, from: data)

        return currencyRates
    }

    private func readDataFromTransactionsPlist() throws -> [String: [TransactionData]]? {
        if cachedTransactionList != nil {
            return cachedTransactionList
        }
        guard let path = Bundle.main.path(forResource: "transactions", ofType: "plist") else { return nil }

        let url = URL(fileURLWithPath: path)

        let data = try Data(contentsOf: url)

        let transactions = try PropertyListDecoder().decode([Transaction].self, from: data)

        var uniqueItems: [String: [TransactionData]] = [:]

        for transaction in transactions {
            if uniqueItems[transaction.sku] == nil {
                uniqueItems[transaction.sku] = [TransactionData(amount: transaction.amount, currency: transaction.currency)]
            } else {
                uniqueItems[transaction.sku]?.append(TransactionData(amount: transaction.amount, currency: transaction.currency))
            }
        }

        cachedTransactionList = uniqueItems

        return uniqueItems
    }

    func getProductsList(completion: @escaping (Result<[String: Int], Error>) -> Void) {
        do {
            guard let transactions = try readDataFromTransactionsPlist() else { return }
            let transactionsMapped = transactions.flatMap { [$0.key: $0.value.count] }
            completion(.success(Dictionary(uniqueKeysWithValues: transactionsMapped)))
        } catch {
            completion(.failure(TechError.fileReadError))
        }
    }

    func getTransactionsByProduct(with sku: String, completion: @escaping (Result<[TransactionData]?, Error>) -> Void) {
        do {
            guard let transactions = try readDataFromTransactionsPlist() else {
                completion(.failure(TechError.fileReadError))
                return
            }
            completion(.success(transactions[sku]))
        } catch {
            completion(.failure(TechError.fileReadError))
        }
    }
}
