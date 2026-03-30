//
//  CMGiftViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：礼物弹层视图；根视图由外层 `CMPopupBoard` 用 frame 驱动位移动画，故不对根视图做 Auto Layout 贴父视图边。

import SnapKit
import UIKit

final class CMGiftViewHolder: CMViewHolder<CMGiftContentModel> {
    private let root = CMGiftPanelRootView()

    /// 选中礼物（由 Board 转 `post(.sendGift)`）。
    var onGiftSelected: ((String) -> Void)?
    /// 点「关闭」。
    var onCloseTapped: (() -> Void)?

    override func build(_ superView: UIView) -> UIView {
        root.translatesAutoresizingMaskIntoConstraints = true
        superView.addSubview(root)
        root.onGiftSelected = { [weak self] id in
            self?.onGiftSelected?(id)
        }
        root.onCloseTapped = { [weak self] in
            self?.onCloseTapped?()
        }
        return root
    }

    func apply(_ model: CMGiftContentModel) {
        root.apply(model: model)
    }

    /// 与 `CMPopupBoard` 动画配合的固定高度。
    static var panelHeight: CGFloat { CMGiftPanelRootView.preferredHeight }
}

// MARK: - Root

private final class CMGiftPanelRootView: UIView {
    static let preferredHeight: CGFloat = 220

    var onGiftSelected: ((String) -> Void)?
    var onCloseTapped: (() -> Void)?

    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.12, alpha: 0.98)
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white

        closeButton.setTitle("关闭", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)

        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.alignment = .fill

        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(stack)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
        }
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-12)
        }
        stack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(100)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var currentGifts: [CMGiftItemModel] = []

    private func makeGiftCell(index: Int, gift: CMGiftItemModel) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = index
        button.backgroundColor = UIColor(white: 0.2, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(giftCellTapped(_:)), for: .touchUpInside)

        let emoji = UILabel()
        emoji.text = gift.emoji
        emoji.font = .systemFont(ofSize: 36)
        emoji.textAlignment = .center
        emoji.isUserInteractionEnabled = false

        let price = UILabel()
        price.text = gift.priceText
        price.font = .systemFont(ofSize: 11, weight: .medium)
        price.textColor = UIColor(white: 0.75, alpha: 1)
        price.textAlignment = .center
        price.isUserInteractionEnabled = false

        button.addSubview(emoji)
        button.addSubview(price)
        emoji.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        price.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().offset(-8)
        }
        return button
    }

    @objc private func giftCellTapped(_ sender: UIButton) {
        guard sender.tag >= 0, sender.tag < currentGifts.count else { return }
        onGiftSelected?(currentGifts[sender.tag].id)
    }

    @objc private func closePressed() {
        onCloseTapped?()
    }

    func apply(model: CMGiftContentModel) {
        currentGifts = model.gifts
        titleLabel.text = model.panelTitle
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, gift) in model.gifts.enumerated() {
            stack.addArrangedSubview(makeGiftCell(index: index, gift: gift))
        }
    }
}
