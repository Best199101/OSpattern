//
//  CMLayoutTypes.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：CMPattern/CMLayout 线性布局参数：边距、测量语义、对齐、子视图附件。`CMLayoutConfig` 为 NSObject 以便关联对象持有。

import Foundation

// MARK: - Margin

public struct CMMargin {
    public var left: CGFloat
    public var top: CGFloat
    public var right: CGFloat
    public var bottom: CGFloat

    public init(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }

    public static let zero = CMMargin(left: 0, top: 0, right: 0, bottom: 0)
}

public func CMMarginMake(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) -> CMMargin {
    CMMargin(left: left, top: top, right: right, bottom: bottom)
}

// MARK: - Axis sizing

/// 单轴：`exact` 用当前 frame 该轴；`atMost` 不超过父上限；`wrapContent` 按内容。
public enum CMLayoutParam {
    case exact
    case atMost
    case wrapContent
}

// MARK: - Gravity

public struct CMLayoutGravity: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let left = CMLayoutGravity(rawValue: 1 << 0)
    public static let right = CMLayoutGravity(rawValue: 1 << 1)
    public static let top = CMLayoutGravity(rawValue: 1 << 2)
    public static let bottom = CMLayoutGravity(rawValue: 1 << 3)
    public static let centerX = CMLayoutGravity(rawValue: 1 << 4)
    public static let centerY = CMLayoutGravity(rawValue: 1 << 5)
    public static let center: CMLayoutGravity = [.centerX, .centerY]
}

// MARK: - Per-child config

public final class CMLayoutConfig: NSObject {
    public var widthSpec: CMLayoutParam = .exact
    public var heightSpec: CMLayoutParam = .exact
    public var margin: CMMargin = CMMarginMake(0, 0, 0, 0)
    public var alignment: CMLayoutGravity = []
    /// 主轴剩余空间按 weight 分配（CMVLayout / CMHLayout）。
    public var weight: Int = 0

    public override init() {
        super.init()
    }

    public convenience init(width: CMLayoutParam, height: CMLayoutParam) {
        self.init()
        widthSpec = width
        heightSpec = height
    }

    public convenience init(width: CMLayoutParam, height: CMLayoutParam, margin: CMMargin) {
        self.init()
        widthSpec = width
        heightSpec = height
        self.margin = margin
    }
}
