//
//  ProductCell.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import Foundation
import UIKit

final class ProductCell: UITableViewCell {
    static let identifier = "ProductCellId"

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var transactionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .darkGray
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        selectionStyle = .none
        setupNameLabel()
        setupArrowImaege()
        setupTransactionsLabel()
    }

    private func setupArrowImaege() {
        addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.trailing.equalToSuperview().inset(16)
            make.width.equalTo(16)
        }
    }

    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    private func setupTransactionsLabel() {
        addSubview(transactionsLabel)
        transactionsLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowIcon.snp.leading).offset(-16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    func configure(with product: Product) {
        nameLabel.text = product.name
        transactionsLabel.text = "\(product.transactionCount) transactions"
    }
}
