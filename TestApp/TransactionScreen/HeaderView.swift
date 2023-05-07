//
//  HeaderView.swift
//  TestApp
//
//  Created by Aleksandr Vyatkin on 07.05.2023.
//

import UIKit

final class HeaderView: UIView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(label)
        backgroundColor = .gray
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    func configure(with sum: String) {
        label.text = "Total: £\(sum)"
    }
}
