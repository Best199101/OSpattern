//
//  ViewController.swift
//  Board
//
//  Created by fei on 2026/3/25.
//

import UIKit

class ViewController: UIViewController {
    private lazy var container: CMLiveRoomContainer = {
        CMLiveRoomContainer(viewController: self, driver: CRDefaultDriver(isAudioLive: false))
    }()

    deinit {
        container.clearContainer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        container.setup(rootView: view)
        container.onLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        container.onAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        container.onDisappear()
    }
}
