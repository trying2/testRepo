//
//  TransactionScreenAssembly.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import UIKit

final class TransactionScreenAssembly {
    static func build(with sku: String) -> UIViewController {
        let fileManager = FileDataManager.shared
        let fileService = FileDataService(FileDataManager: fileManager)
        let model = TransactionModel(fileService: fileService, skuName: sku)
        let vc = TranscationViewController(model: model)
        return vc
    }
}
