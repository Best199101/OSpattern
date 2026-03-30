//
//  CMWhiteCanvasViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板画布区 ViewHolder。

import SnapKit
import UIKit

final class CMWhiteCanvasViewHolder: CMViewHolder<CMWhiteCanvasContentModel> {
    private let root = CMWhiteCanvasRootView()

    override func build(_ superView: UIView) -> UIView {
        superView.addSubview(root)
        // 父级为 `CMVLayout` 时由 `layoutConfig` 分配 frame，勿对 superView 加四边约束以免冲突。
        return root
    }

    func apply(_ model: CMWhiteCanvasContentModel) {
        root.apply(model: model)
    }
}

private final class CMWhiteCanvasRootView: UIView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.75, alpha: 1).cgColor

        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = UIColor(white: 0.35, alpha: 1)
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(14)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(model: CMWhiteCanvasContentModel) {
        titleLabel.text = model.title
    }
}
