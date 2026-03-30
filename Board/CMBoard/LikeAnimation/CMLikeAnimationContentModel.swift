//
//  CMLikeAnimationContentModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：点赞飘心等全屏动效的可调参数（由 `CMLikeAnimationViewHolder` 消费）。

import Foundation

final class CMLikeAnimationContentModel: NSObject {
    var likeEmoji: String
    var iconPointSize: CGFloat
    var horizontalMargin: CGFloat
    var riseDuration: TimeInterval
    /// 相对画布高度向上飘动的比例（0~1）
    var verticalTravelRatio: CGFloat

    init(
        likeEmoji: String = "❤️",
        iconPointSize: CGFloat = 32,
        horizontalMargin: CGFloat = 24,
        riseDuration: TimeInterval = 0.55,
        verticalTravelRatio: CGFloat = 0.35
    ) {
        self.likeEmoji = likeEmoji
        self.iconPointSize = iconPointSize
        self.horizontalMargin = horizontalMargin
        self.riseDuration = riseDuration
        self.verticalTravelRatio = verticalTravelRatio
        super.init()
    }
}
