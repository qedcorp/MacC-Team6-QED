//
//  ScrollObservableViewController.swift
//  QED
//
//  Created by changgyo seo on 11/6/23.
//

import UIKit
import SwiftUI

import Combine

final class ScrollObservableViewController: UIViewController {

    @Binding var offset: CGFloat

    init(offset: Binding<CGFloat>, content: UIView) {
        self._offset = offset
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var content: UIView

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear

        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        layout()
        setContent()
    }

    func setOffset(_ offset: CGFloat, _ content: UIView) {
        self.content = content
        var point = scrollView.contentOffset
        point.x = offset
        scrollView.contentOffset = point
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(content)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor)
        ])

        let contntviewWidth = content.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor)
        contntviewWidth.priority = .defaultLow
        contntviewWidth.isActive = true
    }

    private func setContent() {

    }
}

extension ScrollObservableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offset = scrollView.contentOffset.x
    }
}
