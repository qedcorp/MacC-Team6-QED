//
//  ObjectPlayableViewController.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import UIKit

class ObjectPlayableViewController: ObjectStageViewController {

    var index: Int

    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        setupCenterLines()
    }

    private func setupCenterLines() {
        let renderer = CenterLinesRenderer(color: .green)
        renderer.render(in: view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
