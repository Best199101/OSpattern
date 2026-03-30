//
//  CMLikeAnimationViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：点赞动画 ViewHolder。

import SnapKit
import UIKit

final class CMLikeAnimationViewHolder: CMViewHolder<CMLikeAnimationContentModel> {
    private let canvas = CMLikeAnimationCanvasView()

    override func build(_ superView: UIView) -> UIView {
        superView.addSubview(canvas)
        canvas.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return canvas
    }

    func playLikeBurst(from model: CMLikeAnimationContentModel) {
        canvas.playLikeBurst(from: model)
    }
}

private final class CMLikeAnimationCanvasView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func playLikeBurst(from model: CMLikeAnimationContentModel) {
        let canvasBounds = bounds
        guard canvasBounds.width > 1, canvasBounds.height > 1 else { return }

        let heart = UILabel()
        heart.text = model.likeEmoji
        heart.font = .systemFont(ofSize: model.iconPointSize)
        heart.sizeToFit()
        let iconWidth = heart.bounds.width
        let iconHeight = heart.bounds.height
        let margin = model.horizontalMargin
        heart.frame.origin = CGPoint(
            x: margin + CGFloat.random(in: 0...(max(0, canvasBounds.width - iconWidth - 2 * margin))),
            y: canvasBounds.height - margin - iconHeight
        )
        addSubview(heart)

        heart.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        heart.alpha = 0.9
        UIView.animate(
            withDuration: model.riseDuration,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            heart.transform = CGAffineTransform(scaleX: 1.15, y: 1.15).translatedBy(
                x: 0,
                y: -(canvasBounds.height * model.verticalTravelRatio)
            )
            heart.alpha = 0
        } completion: { _ in
            heart.removeFromSuperview()
        }
    }
}
