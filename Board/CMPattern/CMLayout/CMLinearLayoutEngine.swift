//
//  CMLinearLayoutEngine.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：CMPattern/CMLayout CMVLayout / CMHLayout：在 sizeContent 结果上写子视图 frame；嵌套 CMFlexLayout 递归 layout。

import UIKit

// MARK: - CMVLayout

extension CMVLayout {
    func applyVerticalChildrenLayout(targetSize: CGSize) {
        var yCursor = verticalAxisContentTopInset(targetSize: targetSize)
        let distributableHeight = targetSize.height - contentHeight
        let weightSum = max(contentWeight, 0)

        for child in cmLayoutVisibleOrderedSubviews() {
            let cfg = child.layoutConfig ?? CMLayoutConfig()
            var childSize = measureChildAlongVerticalAxis(
                child: child,
                config: cfg,
                targetSize: targetSize,
                yCursor: yCursor,
                distributableHeight: distributableHeight,
                weightSum: weightSum
            )
            alignChildHorizontallyInColumn(
                child: child,
                childConfig: cfg,
                containerWidth: targetSize.width
            )
            yCursor = placeChildVerticallyOnMainAxis(
                child: child,
                childConfig: cfg,
                yCursor: yCursor,
                layoutSize: &childSize
            )
        }
    }

    private func verticalAxisContentTopInset(targetSize: CGSize) -> CGFloat {
        if gravity.contains(.top) { return 0 }
        if gravity.contains(.bottom) { return targetSize.height - contentHeight }
        if gravity.contains(.centerY) { return (targetSize.height - contentHeight) / 2 }
        return 0
    }

    private func measureChildAlongVerticalAxis(
        child: UIView,
        config: CMLayoutConfig,
        targetSize: CGSize,
        yCursor: CGFloat,
        distributableHeight: CGFloat,
        weightSum: Int
    ) -> CGSize {
        var size = child.sizeThatFits(
            CGSize(width: targetSize.width, height: max(0, targetSize.height - yCursor))
        )
        if config.widthSpec == .exact {
            size.width = child.width
        } else if config.widthSpec == .atMost {
            size.width = targetSize.width
        }
        if config.heightSpec == .exact {
            size.height = child.height
        } else if config.heightSpec == .atMost {
            size.height = max(0, targetSize.height - yCursor)
        }
        if config.weight > 0 {
            size.height = child.height
        }
        if config.weight > 0, weightSum > 0 {
            size.height += distributableHeight / CGFloat(weightSum) * CGFloat(config.weight)
        }
        child.safeWidth = size.width
        child.safeHeight = size.height
        return size
    }

    private func alignChildHorizontallyInColumn(
        child: UIView,
        childConfig: CMLayoutConfig,
        containerWidth: CGFloat
    ) {
        let combined = childConfig.alignment.union(gravity)
        if combined.contains(.left) {
            child.left = 0
        } else if combined.contains(.right) {
            child.right = containerWidth
        } else if combined.contains(.centerX) {
            child.centerX = containerWidth / 2
        } else {
            if childConfig.margin.left != 0 {
                child.left = childConfig.margin.left
            } else if childConfig.margin.right != 0 {
                child.right = containerWidth - childConfig.margin.right
            }
        }
    }

    private func placeChildVerticallyOnMainAxis(
        child: UIView,
        childConfig: CMLayoutConfig,
        yCursor: CGFloat,
        layoutSize: inout CGSize
    ) -> CGFloat {
        var nextY = yCursor
        if childConfig.margin.top != 0 {
            nextY += childConfig.margin.top
        }
        child.top = nextY
        nextY = child.bottom + space
        if childConfig.margin.bottom != 0 {
            nextY += childConfig.margin.bottom
        }
        if let nested = child as? CMFlexLayout {
            nested.layout(targetSize: layoutSize)
        }
        return nextY
    }
}

// MARK: - CMHLayout

extension CMHLayout {
    func applyHorizontalChildrenLayout(targetSize: CGSize) {
        var xCursor = horizontalAxisContentLeadingInset(targetSize: targetSize)
        let distributableWidth = targetSize.width - contentWidth
        let weightSum = max(contentWeight, 0)

        for child in cmLayoutVisibleOrderedSubviews() {
            let cfg = child.layoutConfig ?? CMLayoutConfig()
            var childSize = measureChildAlongHorizontalAxis(
                child: child,
                config: cfg,
                targetSize: targetSize,
                xCursor: xCursor,
                distributableWidth: distributableWidth,
                weightSum: weightSum
            )
            alignChildVerticallyInRow(
                child: child,
                childConfig: cfg,
                containerHeight: targetSize.height
            )
            xCursor = placeChildHorizontallyOnMainAxis(
                child: child,
                childConfig: cfg,
                xCursor: xCursor,
                layoutSize: &childSize
            )
        }
    }

    private func horizontalAxisContentLeadingInset(targetSize: CGSize) -> CGFloat {
        if contentWeight > 0 { return 0 }
        if gravity.contains(.left) { return 0 }
        if gravity.contains(.right) { return targetSize.width - contentWidth }
        if gravity.contains(.centerX) { return (targetSize.width - contentWidth) / 2 }
        return 0
    }

    private func measureChildAlongHorizontalAxis(
        child: UIView,
        config: CMLayoutConfig,
        targetSize: CGSize,
        xCursor: CGFloat,
        distributableWidth: CGFloat,
        weightSum: Int
    ) -> CGSize {
        var size = child.sizeThatFits(
            CGSize(width: max(0, targetSize.width - xCursor), height: targetSize.height)
        )
        if config.widthSpec == .exact {
            size.width = child.width
        } else if config.widthSpec == .atMost {
            size.width = max(0, targetSize.width - xCursor)
        }
        if config.heightSpec == .exact {
            size.height = child.height
        } else if config.heightSpec == .atMost {
            size.height = targetSize.height
        }
        if config.weight > 0 {
            size.width = child.width
        }
        if config.weight > 0, weightSum > 0 {
            size.width += distributableWidth / CGFloat(weightSum) * CGFloat(config.weight)
        }
        child.safeWidth = size.width
        child.safeHeight = size.height
        return size
    }

    private func alignChildVerticallyInRow(
        child: UIView,
        childConfig: CMLayoutConfig,
        containerHeight: CGFloat
    ) {
        let combined = childConfig.alignment.union(gravity)
        if combined.contains(.top) {
            child.top = 0
        } else if combined.contains(.bottom) {
            child.bottom = containerHeight
        } else if combined.contains(.centerY) {
            child.centerY = containerHeight / 2
        } else {
            if childConfig.margin.top != 0 {
                child.top = childConfig.margin.top
            } else if childConfig.margin.bottom != 0 {
                child.bottom = containerHeight - childConfig.margin.bottom
            }
        }
    }

    private func placeChildHorizontallyOnMainAxis(
        child: UIView,
        childConfig: CMLayoutConfig,
        xCursor: CGFloat,
        layoutSize: inout CGSize
    ) -> CGFloat {
        var nextX = xCursor
        if childConfig.margin.left != 0 {
            nextX += childConfig.margin.left
        }
        child.left = nextX
        nextX = child.right + space
        if childConfig.margin.right != 0 {
            nextX += childConfig.margin.right
        }
        if let nested = child as? CMFlexLayout {
            nested.layout(targetSize: layoutSize)
        }
        return nextX
    }
}
