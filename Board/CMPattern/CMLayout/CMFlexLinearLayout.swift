//
//  CMFlexLinearLayout.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：CMPattern/CMLayout CMFlexLayout 与线性子类：测量见 sizeContent；frame 写入见 CMLinearLayoutEngine。类型见 CMLayoutTypes。「Flex」= 主轴线性 + weight，非 CSS Flexbox。

import UIKit
import ObjectiveC

// MARK: - UIView helper

extension UIView {
    func cmLayoutVisibleOrderedSubviews() -> [UIView] {
        subviews.filter { !$0.isHidden }
    }
}

// MARK: - CMFlexLayout

open class CMFlexLayout: UIView {
    public var gravity: CMLayoutGravity = []

    var contentWidth: CGFloat = 0
    var contentHeight: CGFloat = 0
    var contentWeight: Int = 0

    open override func layoutSubviews() {
        super.layoutSubviews()
        if let flexParent = superview as? CMFlexLayout {
            flexParent.layoutIfNeeded()
        } else if let parent = superview {
            let size = sizeThatFits(CGSize(width: parent.width, height: parent.height))
            layout(targetSize: size)
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var width = self.width
        var height = self.height
        let config = layoutConfig ?? CMLayoutConfig()

        if config.widthSpec == .atMost || config.widthSpec == .wrapContent {
            width = size.width - config.margin.left - config.margin.right
        }
        if config.heightSpec == .atMost || config.heightSpec == .wrapContent {
            height = size.height - config.margin.top - config.margin.bottom
        }

        let contentSize = sizeContent(CGSize(width: width, height: height))
        if config.widthSpec == .wrapContent { width = contentSize.width }
        if config.heightSpec == .wrapContent { height = contentSize.height }
        return CGSize(width: width, height: height)
    }

    open func sizeContent(_ size: CGSize) -> CGSize { size }

    open func layout(targetSize: CGSize) {
        safeWidth = targetSize.width
        safeHeight = targetSize.height
    }
}

// MARK: - CMLinearLayout

open class CMLinearLayout: CMFlexLayout {
    public var space: CGFloat = 0
}

// MARK: - CMStack（只测尺寸，不摆 frame）

open class CMStack: CMFlexLayout {
    open override func sizeContent(_ size: CGSize) -> CGSize {
        var maxW: CGFloat = 0
        var maxH: CGFloat = 0
        for child in cmLayoutVisibleOrderedSubviews() {
            let config = child.layoutConfig ?? CMLayoutConfig()
            var childSize = CGSize(width: child.width, height: child.height)
            if child is CMFlexLayout || config.widthSpec == .wrapContent || config.heightSpec == .wrapContent {
                childSize = child.sizeThatFits(size)
            }
            if config.widthSpec == .atMost { childSize.width = size.width }
            if config.heightSpec == .atMost { childSize.height = size.height }
            maxW = max(maxW, childSize.width + config.margin.left + config.margin.right)
            maxH = max(maxH, childSize.height + config.margin.top + config.margin.bottom)
        }
        contentWidth = maxW
        contentHeight = maxH
        return CGSize(width: maxW, height: maxH)
    }
}

// MARK: - CMVLayout

open class CMVLayout: CMLinearLayout {
    open override func sizeContent(_ size: CGSize) -> CGSize {
        var maxRowWidth: CGFloat = 0
        var columnHeightSum: CGFloat = 0
        var totalWeight = 0
        let visible = cmLayoutVisibleOrderedSubviews()
        for child in visible {
            let config = child.layoutConfig ?? CMLayoutConfig()
            var childSize = child.sizeThatFits(CGSize(width: size.width, height: max(0, size.height - columnHeightSum)))
            if config.widthSpec == .exact { childSize.width = child.width }
            if config.widthSpec == .atMost { childSize.width = size.width }
            if config.heightSpec == .exact { childSize.height = child.height }
            if config.heightSpec == .atMost { childSize.height = max(0, size.height - columnHeightSum) }
            if config.weight > 0 { childSize.height = child.height }
            maxRowWidth = max(maxRowWidth, childSize.width + config.margin.left + config.margin.right)
            columnHeightSum += childSize.height + space + config.margin.top + config.margin.bottom
            totalWeight += config.weight
        }
        if !visible.isEmpty { columnHeightSum -= space }
        contentWidth = maxRowWidth
        contentHeight = columnHeightSum
        contentWeight = totalWeight
        return CGSize(width: maxRowWidth, height: totalWeight > 0 ? size.height : columnHeightSum)
    }

    open override func layout(targetSize: CGSize) {
        applyVerticalChildrenLayout(targetSize: targetSize)
        super.layout(targetSize: targetSize)
    }
}

// MARK: - CMHLayout

open class CMHLayout: CMLinearLayout {
    open override func sizeContent(_ size: CGSize) -> CGSize {
        var rowWidthSum: CGFloat = 0
        var maxColumnHeight: CGFloat = 0
        var totalWeight = 0
        let visible = cmLayoutVisibleOrderedSubviews()
        for child in visible {
            let config = child.layoutConfig ?? CMLayoutConfig()
            var childSize = child.sizeThatFits(CGSize(width: max(0, size.width - rowWidthSum), height: size.height))
            if config.widthSpec == .exact { childSize.width = child.width }
            if config.widthSpec == .atMost { childSize.width = max(0, size.width - rowWidthSum) }
            if config.heightSpec == .exact { childSize.height = child.height }
            if config.heightSpec == .atMost { childSize.height = size.height }
            if config.weight > 0 { childSize.width = child.width }
            rowWidthSum += childSize.width + space + config.margin.left + config.margin.right
            maxColumnHeight = max(maxColumnHeight, childSize.height + config.margin.top + config.margin.bottom)
            totalWeight += config.weight
        }
        if !visible.isEmpty { rowWidthSum -= space }
        contentWidth = rowWidthSum
        contentHeight = maxColumnHeight
        contentWeight = totalWeight
        return CGSize(width: totalWeight > 0 ? size.width : rowWidthSum, height: maxColumnHeight)
    }

    open override func layout(targetSize: CGSize) {
        applyHorizontalChildrenLayout(targetSize: targetSize)
        super.layout(targetSize: targetSize)
    }
}

// MARK: - UIView geometry & associated objects

private var cmLayoutConfigAssociatedKey: UInt8 = 0
private var cmTagStringAssociatedKey: UInt8 = 0

public extension UIView {
    var safeWidth: CGFloat {
        get { max(0, frame.width) }
        set {
            var next = frame
            next.size.width = max(0, newValue)
            frame = next
        }
    }

    var safeHeight: CGFloat {
        get { max(0, frame.height) }
        set {
            var next = frame
            next.size.height = max(0, newValue)
            frame = next
        }
    }

    var width: CGFloat {
        get { frame.width }
        set { frame.size.width = newValue }
    }

    var height: CGFloat {
        get { frame.height }
        set { frame.size.height = newValue }
    }

    var left: CGFloat {
        get { frame.origin.x }
        set { frame.origin.x = newValue }
    }

    var right: CGFloat {
        get { frame.origin.x + frame.width }
        set { frame.origin.x = newValue - frame.width }
    }

    var top: CGFloat {
        get { frame.origin.y }
        set { frame.origin.y = newValue }
    }

    var bottom: CGFloat {
        get { frame.origin.y + frame.height }
        set { frame.origin.y = newValue - frame.height }
    }

    var centerX: CGFloat {
        get { center.x }
        set { center.x = newValue }
    }

    var centerY: CGFloat {
        get { center.y }
        set { center.y = newValue }
    }

    var layoutConfig: CMLayoutConfig? {
        get { objc_getAssociatedObject(self, &cmLayoutConfigAssociatedKey) as? CMLayoutConfig }
        set {
            objc_setAssociatedObject(
                self,
                &cmLayoutConfigAssociatedKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /// 写入时同步到 `tag`（hash），便于 `viewWithTag`。
    var tagString: String? {
        get { objc_getAssociatedObject(self, &cmTagStringAssociatedKey) as? String }
        set {
            objc_setAssociatedObject(self, &cmTagStringAssociatedKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            tag = newValue?.hashValue ?? 0
        }
    }

    func view(withTagString tagString: String) -> UIView? {
        viewWithTag(tagString.hashValue)
    }

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func add(to superView: UIView) {
        superView.addSubview(self)
    }
}

// MARK: - Factories

public func cmVLayout(_ views: [UIView]) -> CMVLayout {
    let layout = CMVLayout(frame: .zero)
    views.forEach { layout.addSubview($0) }
    layout.layoutConfig = CMLayoutConfig(width: .wrapContent, height: .wrapContent)
    return layout
}

public func cmHLayout(_ views: [UIView]) -> CMHLayout {
    let layout = CMHLayout(frame: .zero)
    views.forEach { layout.addSubview($0) }
    layout.layoutConfig = CMLayoutConfig(width: .wrapContent, height: .wrapContent)
    return layout
}

public func cmStack(_ views: [UIView]) -> CMStack {
    let layout = CMStack(frame: .zero)
    views.forEach { layout.addSubview($0) }
    layout.layoutConfig = CMLayoutConfig(width: .wrapContent, height: .wrapContent)
    return layout
}
