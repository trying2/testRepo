//
//  CurrencySymbol.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

enum CurrencySymbol: String {
    case usd
    case gbp
    case cad
    case aud

    func symbol() -> String {
        switch self {
        case .usd:
            return "$"
        case .gbp:
            return "£"
        case .cad:
            return "C$"
        case .aud:
            return "A"
        }
    }
}
