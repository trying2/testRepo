//
//  CurrencyRateDTO.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

struct CurrencyRateDTO {
    let from: String
    let rate: Double
    let to: String
}

extension CurrencyRateDTO {
    init(from data: CurrencyRate) {
        self.from = data.from
        self.to = data.to
        if let rate = Double(data.rate) {
            self.rate = rate
        } else {
            self.rate = 1
        }
    }
}
