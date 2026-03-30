//
//  CMLiveRoomContainer.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：参考融合 `CRContainer`：持有 `UIViewController`、`CMDriver`，并按 `isAudioLive` 返回根 Board 类型栈。

import UIKit

open class CMLiveRoomContainer: CMRoomContainer {
    public var driver: CMDriver

    deinit {
        #if DEBUG
        print("[CR][融合] CMLiveRoomContainer 销毁了")
        #endif
    }

    public init(viewController: UIViewController, driver: CMDriver) {
        self.driver = driver
        super.init()
        self.viewController = viewController
    }

    // MARK: - Boards（与 CRContainer 结构对应）

    /// 根 Board 类型列表（顺序即创建与 `setup(in:)` 顺序，下同层叠 Z 序：靠前偏下）。
    open var boards: [AnyClass] {
        boardsDefault
    }

    /// 默认（L0 逻辑 → L1 背景 → L2 渲染 → L3 主界面 → … → L9 顶层。
    private var boardsDefault: [AnyClass] {
        [
            CMLogicLayerBoard.self,
            CMBackgroundLayerBoard.self,
            CMRenderLayerBoard.self,
            CMLiveRoomMainLayerBoard.self,
            CMAnimationLayerBoard.self,
            CMFloatLayerBoard.self,
            CMPopupLayerBoard.self,
            CMGuideLayerBoard.self,
            CMTopLayerBoard.self
        ]
    }

    // MARK: - CMContainer

    open override func rootBoardTypes() -> [CMBoard.Type] {
        boards.compactMap { $0 as? CMBoard.Type }
    }
}
