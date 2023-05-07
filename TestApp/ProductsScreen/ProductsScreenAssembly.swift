//
//  ProductsScreenAssembly.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import Foundation
import UIKit

final class ProductsScreenAssembly {
    static func build() -> UIViewController {
        let fileManager = FileDataManager.shared
        let fileService = FileDataService(FileDataManager: fileManager)
        let model = ProductsModel(fileService: fileService)
        let vc = ProductsViewController(model: model)
        vc.title = "Products"
        return vc
    }
}
