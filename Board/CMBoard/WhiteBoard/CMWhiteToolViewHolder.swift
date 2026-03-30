//
//  CMWhiteToolViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板工具区 ViewHolder。

import SnapKit
import UIKit

final class CMWhiteToolViewHolder: CMViewHolder<CMWhiteToolContentModel> {
    private let root = CMWhiteToolBarRootView()

    override func build(_ superView: UIView) -> UIView {
        superView.addSubview(root)
        // 父级为 `CMVLayout` 时由 `layoutConfig` 分配 frame，勿对 superView 加四边约束以免冲突。
        return root
    }

    func apply(_ model: CMWhiteToolContentModel) {
        root.apply(model: model)
    }
}

private final class CMWhiteToolBarRootView: UIView {
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.24, alpha: 1)

        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 6
        stack.distribution = .fillEqually
        addSubview(stack)

        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 2))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(model: CMWhiteToolContentModel) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for item in model.items {
            let button = makeToolButton(item: item)
            stack.addArrangedSubview(button)
        }
    }

    private func makeToolButton(item: CMToolItemModel) -> UIButton {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let img = UIImage(systemName: item.symbolName, withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = UIColor(white: 0.92, alpha: 1)
        btn.accessibilityLabel = item.title
        btn.adjustsImageWhenHighlighted = true

        btn.backgroundColor = UIColor(white: 1, alpha: 0.06)
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.contentMode = .center
        btn.imageView?.contentMode = .scaleAspectFit

        // 预留：业务可在 ViewModel 里绑定 tag / 闭包
        btn.accessibilityIdentifier = "whiteboard.tool.\(item.symbolName)"

        return btn
    }
}
