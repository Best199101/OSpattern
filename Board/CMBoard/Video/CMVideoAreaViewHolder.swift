//
//  CMVideoAreaViewHolder.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：`CMViewHolder` 子类：视频区域根视图（横滑条 + 多路宫格），仅负责视图结构与装配子 Holder。

import SnapKit
import UIKit

final class CMVideoAreaViewHolder: CMViewHolder<CMVideoContentModel> {
    private(set) var tileViewModels: [CMVideoTileViewModel] = []

    override func build(_ superView: UIView) -> UIView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        superView.addSubview(scrollView)

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = CMVideoLayout.horizontalSpacing
        stack.alignment = .fill
        scrollView.addSubview(stack)

        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CMVideoLayout.stripInsets.top)
            make.leading.equalToSuperview().offset(CMVideoLayout.stripInsets.left)
            make.trailing.equalToSuperview().offset(-CMVideoLayout.stripInsets.right)
            make.bottom.equalToSuperview().offset(-CMVideoLayout.stripInsets.bottom)
        }

        stack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide.snp.height)
        }

        var vms: [CMVideoTileViewModel] = []
        for slotIndex in 0..<CMVideoLayout.slotCount {
            let tileContainer = UIView()
            tileContainer.snp.makeConstraints { make in
                make.width.equalTo(CMVideoLayout.tileWidth)
            }
            stack.addArrangedSubview(tileContainer)

            let participant = CMVideoParticipantModel(slotIndex: slotIndex)
            let tileHolder = CMVideoTileViewHolder(superView: tileContainer)
            let tileVM = CMVideoTileViewModel(model: participant, viewHolder: tileHolder)
            vms.append(tileVM)
        }
        tileViewModels = vms

        return scrollView
    }
}
