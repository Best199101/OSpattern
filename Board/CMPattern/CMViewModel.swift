//
//  CMViewModel.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：Model + CMViewHolder；变更后主线程 `bind`。

import Foundation

open class CMViewModel<Model: AnyObject, VH: CMViewHolder<Model>> {
    public typealias ModelUpdate = (Model) -> Void
    public typealias ModelSetter = ModelUpdate

    public let model: Model
    public let viewHolder: VH

    public required init(model: Model, viewHolder: VH) {
        self.model = model
        self.viewHolder = viewHolder
        bindOnce()
        bind(model: model, viewHolder: viewHolder)
    }

    open func bind(model: Model, viewHolder: VH) {
        fatalError("子类必须实现 bind(model:viewHolder:)")
    }

    open func bindOnce() {}

    /// `update` 在调用线程同步执行；随后 `main.async` 调 `bind`。
    public func updateModel(_ update: ModelUpdate) {
        update(model)
        CMMainQueue.async { [weak self] in
            guard let self else { return }
            self.bind(model: self.model, viewHolder: self.viewHolder)
        }
    }

    /// 仅主线程再执行一次 `bind`。
    public func refreshViewBinding() {
        CMMainQueue.async { [weak self] in
            guard let self else { return }
            self.bind(model: self.model, viewHolder: self.viewHolder)
        }
    }
}
