//
//  CMStatusViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：状态栏区域视图持有者。

import SnapKit
import UIKit

final class CMStatusViewHolder: CMViewHolder<CMStatusContentModel> {
    private let root = CMStatusBarRootView()

    var onMicTapped: (() -> Void)? {
        didSet { root.onMicTapped = onMicTapped }
    }

    var onCameraTapped: (() -> Void)? {
        didSet { root.onCameraTapped = onCameraTapped }
    }

    var onFlipCameraTapped: (() -> Void)? {
        didSet { root.onFlipCameraTapped = onFlipCameraTapped }
    }

    override func build(_ superView: UIView) -> UIView {
        superView.addSubview(root)
        root.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        root.onMicTapped = onMicTapped
        root.onCameraTapped = onCameraTapped
        root.onFlipCameraTapped = onFlipCameraTapped
        return root
    }

    func apply(_ model: CMStatusContentModel) {
        root.apply(model: model)
    }
}

private final class CMStatusBarRootView: UIView {
    var onMicTapped: (() -> Void)?
    var onCameraTapped: (() -> Void)?
    var onFlipCameraTapped: (() -> Void)?

    /// 左右等宽，中间 `centerToolbar` 自然落在屏幕水平正中，两侧从中间向边沿铺开。
    private let outerRow = UIStackView()
    private let leftWing = UIView()
    private let rightWing = UIView()
    private let leftLabel = UILabel()
    /// 靠中间一侧：翻转 → 摄像头 → 麦克风
    private let leftControlsStack = UIStackView()
    private let centerToolbar = UIStackView()
    private let liveBadge = UILabel()
    private let titleLabel = UILabel()
    private let rightStack = UIStackView()

    private let micButton = UIButton(type: .system)
    private let cameraButton = UIButton(type: .system)
    private let flipButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.07, alpha: 1)
        setUpStatusBarContent()
    }

    private func setUpStatusBarContent() {
        leftLabel.font = .systemFont(ofSize: 11, weight: .regular)
        leftLabel.textColor = UIColor(white: 0.75, alpha: 1)
        leftLabel.numberOfLines = 1
        leftLabel.lineBreakMode = .byTruncatingTail
        leftLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .natural
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        // 禁止把标题拉成「通栏」，否则中间区极宽、视觉上不居中且与右侧留白畸形
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        liveBadge.font = .systemFont(ofSize: 10, weight: .bold)
        liveBadge.textColor = .white
        liveBadge.backgroundColor = UIColor(red: 0.85, green: 0.2, blue: 0.2, alpha: 1)
        liveBadge.textAlignment = .center
        liveBadge.layer.cornerRadius = 4
        liveBadge.layer.masksToBounds = true
        liveBadge.setContentHuggingPriority(.required, for: .horizontal)

        centerToolbar.axis = .horizontal
        centerToolbar.spacing = 8
        centerToolbar.alignment = .center
        centerToolbar.distribution = .fill
        centerToolbar.setContentHuggingPriority(.required, for: .horizontal)
        centerToolbar.setContentCompressionResistancePriority(.required, for: .horizontal)
        centerToolbar.addArrangedSubview(liveBadge)
        centerToolbar.addArrangedSubview(titleLabel)

        configureIconButton(flipButton, symbolName: "arrow.triangle.2.circlepath.camera", action: #selector(flipTapped))
        configureIconButton(cameraButton, symbolName: "video.fill", action: #selector(cameraTapped))
        configureIconButton(micButton, symbolName: "mic.fill", action: #selector(micTapped))

        leftControlsStack.axis = .horizontal
        leftControlsStack.spacing = 4
        leftControlsStack.alignment = .center
        leftControlsStack.addArrangedSubview(flipButton)
        leftControlsStack.addArrangedSubview(cameraButton)
        leftControlsStack.addArrangedSubview(micButton)

        rightStack.axis = .horizontal
        rightStack.spacing = 10
        rightStack.alignment = .center

        let wifi = UIImageView(image: UIImage(systemName: "wifi"))
        wifi.tintColor = UIColor(white: 0.75, alpha: 1)
        wifi.contentMode = .scaleAspectFit
        wifi.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }

        let battery = UIImageView(image: UIImage(systemName: "battery.100"))
        battery.tintColor = UIColor(white: 0.75, alpha: 1)
        battery.contentMode = .scaleAspectFit
        battery.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(14)
        }

        rightStack.addArrangedSubview(wifi)
        rightStack.addArrangedSubview(battery)

        let leftInner = UIStackView()
        leftInner.axis = .horizontal
        leftInner.spacing = 6
        leftInner.alignment = .center
        leftInner.addArrangedSubview(leftLabel)
        leftInner.addArrangedSubview(leftControlsStack)

        leftWing.addSubview(leftInner)
        rightWing.addSubview(rightStack)

        outerRow.axis = .horizontal
        outerRow.alignment = .center
        outerRow.distribution = .fill
        outerRow.spacing = 0
        outerRow.addArrangedSubview(leftWing)
        outerRow.addArrangedSubview(centerToolbar)
        outerRow.addArrangedSubview(rightWing)

        leftWing.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightWing.setContentHuggingPriority(.defaultLow, for: .horizontal)

        addSubview(outerRow)

        outerRow.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }

        leftWing.snp.makeConstraints { make in
            make.width.equalTo(rightWing.snp.width)
        }

        leftInner.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }

        rightStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
    }

    private func configureIconButton(_ button: UIButton, symbolName: String, action: Selector) {
        let sym = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
        button.setImage(UIImage(systemName: symbolName, withConfiguration: sym), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
    }

    @objc private func micTapped() {
        onMicTapped?()
    }

    @objc private func cameraTapped() {
        onCameraTapped?()
    }

    @objc private func flipTapped() {
        onFlipCameraTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(model: CMStatusContentModel) {
        leftLabel.text = model.statusSubtitle
        titleLabel.text = model.roomTitle
        liveBadge.text = model.isLive ? " LIVE " : " 未开播 "
        liveBadge.backgroundColor = model.isLive
            ? UIColor(red: 0.85, green: 0.2, blue: 0.2, alpha: 1)
            : UIColor(white: 0.35, alpha: 1)

        let micOn = model.isMicEnabled
        micButton.setImage(UIImage(systemName: micOn ? "mic.fill" : "mic.slash.fill"), for: .normal)
        micButton.tintColor = micOn ? .white : UIColor(white: 0.45, alpha: 1)

        let camOn = model.isCameraEnabled
        cameraButton.setImage(UIImage(systemName: camOn ? "video.fill" : "video.slash.fill"), for: .normal)
        cameraButton.tintColor = camOn ? .white : UIColor(white: 0.45, alpha: 1)
    }
}
