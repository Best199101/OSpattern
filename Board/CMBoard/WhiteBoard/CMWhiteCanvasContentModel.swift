//
//  CMWhiteCanvasContentModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板画布区展示数据（后续可接笔迹、背景图等）。

import Foundation

final class CMWhiteCanvasContentModel: NSObject {
    var title: String

    init(title: String = "白板") {
        self.title = title
        super.init()
    }
}
