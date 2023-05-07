//
//  TransactionDataDTO.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import Foundation

struct TransactionDataDTO {
    let amount: Double
    let currency: String
}

extension TransactionDataDTO {
    init(from data: TransactionData) {
        if let amount = Double(data.amount) {
            self.amount = amount
        } else {
            amount = 0
        }
        self.currency = data.currency
    }
}
