//
//  CMGiftContentModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：礼物弹层内容模型。

import Foundation

/// 单个礼物项（列表数据源）。
struct CMGiftItemModel: Equatable, Sendable {
    let id: String
    let emoji: String
    let priceText: String
}

/// 礼物面板内容数据。
final class CMGiftContentModel: NSObject {
    var panelTitle: String
    var gifts: [CMGiftItemModel]

    init(panelTitle: String = "送礼", gifts: [CMGiftItemModel] = CMGiftContentModel.defaultGifts()) {
        self.panelTitle = panelTitle
        self.gifts = gifts
        super.init()
    }

    private static func defaultGifts() -> [CMGiftItemModel] {
        [
            CMGiftItemModel(id: "rose", emoji: "🌹", priceText: "1 币"),
            CMGiftItemModel(id: "cake", emoji: "🎂", priceText: "10 币"),
            CMGiftItemModel(id: "rocket", emoji: "🚀", priceText: "100 币")
        ]
    }
}
