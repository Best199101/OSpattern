//
//  CMArrayExtensions.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：Array 带索引的遍历便捷方法。

import Foundation

public extension Array {
    func forEachIndexed(_ body: (Element, Int) -> Void) {
        for (index, element) in enumerated() {
            body(element, index)
        }
    }

    func mapIndexed<T>(_ transform: (Element, Int) -> T) -> [T] {
        enumerated().map { transform($0.element, $0.offset) }
    }

    /// 等价于 `enumerated().flatMap`。
    func flatMapIndexed<T>(_ transform: (Element, Int) -> [T]) -> [T] {
        enumerated().flatMap { transform($0.element, $0.offset) }
    }

    func filterIndexed(_ isIncluded: (Element, Int) -> Bool) -> [Element] {
        enumerated().filter { isIncluded($0.element, $0.offset) }.map(\.element)
    }
}
