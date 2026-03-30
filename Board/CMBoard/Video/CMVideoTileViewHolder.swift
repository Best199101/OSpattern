//
//  CMVideoTileViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：`CMViewHolder` 子类：单路视频宫格视图。

import SnapKit
import UIKit

final class CMVideoTileViewHolder: CMViewHolder<CMVideoParticipantModel> {
    private let cardView = CMVideoTileRootView()

    override func build(_ superView: UIView) -> UIView {
        superView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return cardView
    }

    func apply(_ model: CMVideoParticipantModel) {
        cardView.apply(model: model)
    }
}

/// 宫格根视图。
private final class CMVideoTileRootView: UIView {
    private let avatarPlaceholder = UIView()
    private let nameLabel = UILabel()
    private let badgeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.12, alpha: 1)
        layer.cornerRadius = 8
        layer.masksToBounds = true

        avatarPlaceholder.backgroundColor = UIColor(white: 0.22, alpha: 1)
        avatarPlaceholder.layer.cornerRadius = 4

        nameLabel.font = .systemFont(ofSize: 11, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center

        badgeLabel.font = .systemFont(ofSize: 9, weight: .regular)
        badgeLabel.textColor = UIColor(white: 0.65, alpha: 1)
        badgeLabel.textAlignment = .center

        addSubview(avatarPlaceholder)
        addSubview(nameLabel)
        addSubview(badgeLabel)

        avatarPlaceholder.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.height.equalTo(avatarPlaceholder.snp.width).multipliedBy(0.62)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarPlaceholder.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
        }

        badgeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.bottom.lessThanOrEqualToSuperview().offset(-4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(model: CMVideoParticipantModel) {
        nameLabel.text = model.displayName
        badgeLabel.text = model.subtitle
    }
}
