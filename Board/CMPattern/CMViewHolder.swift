//
//  CMViewHolder.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：在 superView 语境下构建并缓存根 UIView。

import UIKit

open class CMViewHolder<Model> {
    public weak var superView: UIView?
    private var cachedRootView: UIView?

    public var view: UIView {
        if let cached = cachedRootView { return cached }
        let built = build(superView ?? UIView())
        cachedRootView = built
        return built
    }

    public required init(superView: UIView) {
        self.superView = superView
        self.cachedRootView = build(superView)
    }

    open func build(_ superView: UIView) -> UIView {
        fatalError("子类需要实现 build(_:)")
    }
}
