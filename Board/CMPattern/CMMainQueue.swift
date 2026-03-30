//
//  CMMainQueue.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：主线程切换统一入口，避免业务层散落 `DispatchQueue.main` / `Thread.isMainThread` 判断。

import Foundation

public enum CMMainQueue {
    /// 已在主线程则立刻执行，否则异步派发到主队列。
    public static func asyncIfNeeded(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }

    /// 始终异步派发到主队列（含当前已在主线程时，也会排到下一轮 runloop）。
    public static func async(execute work: @escaping () -> Void) {
        DispatchQueue.main.async(execute: work)
    }

    /// 已在主线程则立刻执行，否则同步等待主队列（注意死锁风险）。
    public static func sync<T>(execute work: () -> T) -> T {
        if Thread.isMainThread {
            return work()
        }
        var result: T!
        DispatchQueue.main.sync { result = work() }
        return result
    }
}
