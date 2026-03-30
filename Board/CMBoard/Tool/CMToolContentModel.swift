//
//  CMToolContentModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：工具栏内容模型。

import Foundation

final class CMToolContentModel: NSObject {
    var items: [CMToolItemModel]

    init(items: [CMToolItemModel] = CMToolContentModel.defaultTools()) {
        self.items = items
        super.init()
    }

    private static func defaultTools() -> [CMToolItemModel] {
        [
            CMToolItemModel(title: "点赞", symbolName: "hand.thumbsup.fill", kind: .like),
            CMToolItemModel(title: "礼物", symbolName: "gift.fill", kind: .gift),
            CMToolItemModel(title: "举手", symbolName: "hand.raised.fill", kind: .raiseHand),
        ]
    }
}
