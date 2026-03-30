//
//  CMWhiteToolContentModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板底部工具条数据（与 `CMToolItemModel` 复用单项结构）。

import Foundation

final class CMWhiteToolContentModel: NSObject {
    var items: [CMToolItemModel]

    init(items: [CMToolItemModel] = CMWhiteToolContentModel.defaultTools()) {
        self.items = items
        super.init()
    }

    private static func defaultTools() -> [CMToolItemModel] {
        [
            CMToolItemModel(title: "画笔", symbolName: "pencil.tip", kind: .whiteboardPen),
            CMToolItemModel(title: "橡皮", symbolName: "eraser", kind: .whiteboardEraser),
            CMToolItemModel(title: "撤销", symbolName: "arrow.uturn.backward", kind: .whiteboardUndo),
            CMToolItemModel(title: "清屏", symbolName: "trash", kind: .whiteboardClear),
        ]
    }
}
