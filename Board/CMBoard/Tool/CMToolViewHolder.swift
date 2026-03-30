//
//  CMToolViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：工具栏视图持有者。

import SnapKit
import UIKit

final class CMToolViewHolder: CMViewHolder<CMToolContentModel> {
    private let root = CMToolBarRootView()

    /// 主线程点击回调；在创建 `CMToolViewModel` 前赋值即可在首次 `bind` 里生效。
    var onItemSelected: ((CMToolItemKind) -> Void)? {
        didSet { root.onItemSelected = onItemSelected }
    }

    override func build(_ superView: UIView) -> UIView {
        superView.addSubview(root)
        root.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        root.onItemSelected = onItemSelected
        return root
    }

    func apply(_ model: CMToolContentModel) {
        root.apply(model: model)
    }
}

private final class CMToolBarRootView: UIView {
    private let outerStack = UIStackView()
    private let buttonStack = UIStackView()
    var onItemSelected: ((CMToolItemKind) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.11, alpha: 1)

        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fill
        buttonStack.alignment = .center

        let leadingSpacer = UIView()
        let trailingSpacer = UIView()
        for spacer in [leadingSpacer, trailingSpacer] {
            spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
            spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        outerStack.axis = .horizontal
        outerStack.distribution = .fill
        outerStack.alignment = .center
        outerStack.addArrangedSubview(leadingSpacer)
        outerStack.addArrangedSubview(buttonStack)
        outerStack.addArrangedSubview(trailingSpacer)

        addSubview(outerStack)

        outerStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-6)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(model: CMToolContentModel) {
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for item in model.items {
            let control = CMToolItemControl(item: item)
            control.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
            buttonStack.addArrangedSubview(control)
        }
    }

    @objc private func itemTapped(_ sender: CMToolItemControl) {
        onItemSelected?(sender.item.kind)
    }
}

private final class CMToolItemControl: UIControl {
    let item: CMToolItemModel

    /// 触控区域至少约 44pt；仅靠 `point(inside:)` 无法扩大命中（父级 `hitTest` 按 `frame` 裁剪）。
    private let contentRow = UIStackView()
    private let minTouchSide: CGFloat = 44
    private let horizontalInset: CGFloat = 12
    private let verticalInset: CGFloat = 10

    init(item: CMToolItemModel) {
        self.item = item
        super.init(frame: .zero)
        contentRow.isUserInteractionEnabled = false
        contentRow.axis = .horizontal
        contentRow.spacing = 6
        contentRow.alignment = .center

        let icon = UIImageView(image: UIImage(systemName: item.symbolName))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }

        let title = UILabel()
        title.text = item.title
        title.font = .systemFont(ofSize: 12, weight: .medium)
        title.textColor = .white

        contentRow.addArrangedSubview(icon)
        contentRow.addArrangedSubview(title)
        addSubview(contentRow)
        contentRow.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(horizontalInset)
            make.trailing.lessThanOrEqualToSuperview().offset(-horizontalInset)
            make.top.greaterThanOrEqualToSuperview().offset(verticalInset)
            make.bottom.lessThanOrEqualToSuperview().offset(-verticalInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let rowSize = contentRow.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let w = max(rowSize.width + horizontalInset * 2, minTouchSide)
        let h = max(rowSize.height + verticalInset * 2, minTouchSide)
        return CGSize(width: w, height: h)
    }
}
