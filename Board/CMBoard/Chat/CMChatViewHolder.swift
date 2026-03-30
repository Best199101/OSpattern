//
//  CMChatViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：公屏聊天 ViewHolder。

import SnapKit
import UIKit

final class CMChatViewHolder: CMViewHolder<CMChatContentModel> {
    private let root = CMChatRootView()

    override func build(_ superView: UIView) -> UIView {
        superView.addSubview(root)
        root.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return root
    }

    func apply(_ model: CMChatContentModel) {
        root.apply(model: model)
    }
}

private final class CMChatRootView: UIView {
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let messageStack = UIStackView()
    private let inputRow = UIStackView()
    private let inputField = UITextField()
    private let sendButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.08, alpha: 1)

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        messageStack.axis = .vertical
        messageStack.spacing = 8
        messageStack.alignment = .fill
        scrollView.addSubview(messageStack)

        inputField.borderStyle = .roundedRect
        inputField.placeholder = "说点什么…"
        inputField.font = .systemFont(ofSize: 13)
        inputField.contentVerticalAlignment = .center

        sendButton.setTitle("发送", for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        sendButton.tintColor = .systemBlue

        inputRow.axis = .horizontal
        inputRow.spacing = 8
        inputRow.alignment = .center
        inputRow.distribution = .fill
        inputRow.addArrangedSubview(inputField)
        inputRow.addArrangedSubview(sendButton)

        addSubview(titleLabel)
        addSubview(scrollView)
        addSubview(inputRow)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputRow.snp.top).offset(-8)
        }

        messageStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top).offset(8)
            make.leading.equalTo(scrollView.contentLayoutGuide.snp.leading).offset(12)
            make.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing).offset(-12)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).offset(-8)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width).offset(-24)
        }

        inputRow.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        inputField.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(model: CMChatContentModel) {
        titleLabel.text = model.title
        messageStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for msg in model.messages {
            let bubble = UILabel()
            bubble.numberOfLines = 0
            bubble.font = .systemFont(ofSize: 12)
            bubble.textColor = .white
            bubble.text = msg.text
            bubble.layer.cornerRadius = 6
            bubble.layer.masksToBounds = true
            if msg.isOutgoing {
                bubble.backgroundColor = UIColor(red: 0.35, green: 0.25, blue: 0.55, alpha: 1)
                bubble.textAlignment = .right
            } else {
                bubble.backgroundColor = UIColor(white: 0.18, alpha: 1)
                bubble.textAlignment = .left
            }
            messageStack.addArrangedSubview(bubble)
        }
    }
}
