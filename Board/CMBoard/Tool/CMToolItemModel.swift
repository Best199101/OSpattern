//
//  CMToolItemModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：工具栏单项数据模型。

import Foundation

enum CMToolItemKind {
    case like
    case gift
    case raiseHand
    case whiteboardPen
    case whiteboardEraser
    case whiteboardUndo
    case whiteboardClear
}

/// 单个工具项（展示用）。
final class CMToolItemModel: NSObject {
    var title: String
    /// `SF Symbols` 名称，如 `pencil`、`hand.raised`。
    var symbolName: String
    var kind: CMToolItemKind

    init(title: String, symbolName: String, kind: CMToolItemKind) {
        self.title = title
        self.symbolName = symbolName
        self.kind = kind
        super.init()
    }
}
