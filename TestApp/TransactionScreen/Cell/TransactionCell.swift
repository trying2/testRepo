//
//  TransactionCell.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import UIKit

final class TransactionCell: UITableViewCell {
    static let identifier = "TransactionCellId"

    private lazy var currentCurrencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var GBPCurrencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
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
        setupCurrentCurrencyLabel()
        setupGBPCurrencyLabel()
    }

    private func setupCurrentCurrencyLabel() {
        addSubview(currentCurrencyLabel)
        currentCurrencyLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    private func setupGBPCurrencyLabel() {
        addSubview(GBPCurrencyLabel)
        GBPCurrencyLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    func configure(with transactionData: TransactionDisplayData) {

        currentCurrencyLabel.text = "\(transactionData.currentCurrencySymbol)\(transactionData.currentCurrencyAmount)"

        GBPCurrencyLabel.text = "\(transactionData.gbpCurrencyAmount)"
    }
}
