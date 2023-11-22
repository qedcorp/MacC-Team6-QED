//
//  ScrollObservableCollectionViewCell.swift
//  QED
//
//  Created by changgyo seo on 11/7/23.
//

import UIKit

import SnapKit
import SwiftUI

class ScrollObservableCollectionViewCell: UICollectionViewCell {

    typealias ViewContants = ScrollObservableView
    static var identifier = "ScrollObservableCollectionViewCell"
    var formation: Formation? {
        didSet {
            if formation != nil {
                layout()
            }
        }
    }
    var hasTransition: Bool = true
    var index = 0
    var isEditMode: Bool = false
    var isCurrentFormation = false {
        didSet {
            changeColorWithSelection(isCurrentFormation)
        }
    }

    var formationFrame: UIView = UIView()

    var transitionFrameWrapperView: UIView = UIView()

    var transitionFrame: CAShapeLayer = CAShapeLayer()

    var numberRectangle: UIView = UIView()

    var numberLabel: UILabel = UILabel()

    var lyricsLabel: UILabel = UILabel()

    override func prepareForReuse() {
        [formationFrame, transitionFrameWrapperView].forEach { $0.removeFromSuperview() }
        [transitionFrame].forEach { $0.removeFromSuperlayer() }
        self.formation = nil
    }

    func changeColorWithSelection(_ isIt: Bool) {
        if isIt {
            formationFrame.layer.borderWidth = 2
            formationFrame.backgroundColor = .blueLight1
            formationFrame.layer.borderColor = UIColor.blueLight3.cgColor
            numberRectangle.backgroundColor = .blueLight3
            lyricsLabel.textColor = .blueLight3
            transitionFrame.strokeColor = UIColor.blueLight3.cgColor
            transitionFrame.path = path(in: transitionFrameWrapperView.frame).cgPath
        } else {
            formationFrame.layer.borderWidth = 2
            formationFrame.backgroundColor = .monoNormal2
            formationFrame.layer.borderColor = UIColor.clear.cgColor
            numberRectangle.backgroundColor = .white
            lyricsLabel.textColor = .white
            transitionFrame.strokeColor = UIColor.monoDark.cgColor
            transitionFrame.path = path(in: transitionFrameWrapperView.frame).cgPath
        }
    }

    private func layout() {
        let objecStageViewController = ObjectStageViewController(copiedFormable: formation, frame: CGRect(origin: .zero, size: CGSize(width: 94, height: 61)))
        formationFrame = objecStageViewController.view
        formationFrame.layer.masksToBounds = true
        formationFrame.layer.cornerRadius = 5

        [formationFrame, numberRectangle, lyricsLabel].forEach { addSubview($0) }
        formationFrame.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.equalTo(ViewContants.Constants.formationFrame.width)
            $0.height.equalTo(ViewContants.Constants.formationFrame.height)
        }

        numberRectangle.layer.masksToBounds = true
        numberRectangle.layer.cornerRadius = 3
        numberRectangle.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(13)
            $0.height.equalTo(13)
            $0.top.equalTo(formationFrame.snp.bottom).offset(3)
        }

        numberRectangle.addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        numberLabel.text = "\(index)"
        numberLabel.textColor = .monoBlack
        numberLabel.minimumScaleFactor = 0.3
        numberLabel.font = .preferredFont(forTextStyle: .caption2)

        lyricsLabel.text = formation?.memo ?? "대형 \(index)"
        lyricsLabel.textColor = .monoBlack
        lyricsLabel.minimumScaleFactor = 0.3
        lyricsLabel.font = .preferredFont(
            forTextStyle: .caption2,
            compatibleWith: .init(legibilityWeight: .bold)
        )
        lyricsLabel.snp.makeConstraints {
            $0.centerY.equalTo(numberRectangle.snp.centerY)
            $0.leading.equalTo(numberRectangle.snp.trailing).offset(3)
            $0.trailing.equalTo(formationFrame.snp.trailing)
            $0.height.equalTo(numberRectangle.snp.height)
        }

        if hasTransition {
            [transitionFrameWrapperView].forEach { addSubview($0) }
            transitionFrame.lineWidth = 1.5
            transitionFrame.strokeColor = UIColor.white.cgColor
            transitionFrame.fillColor = UIColor.clear.cgColor
            transitionFrameWrapperView.layer.addSublayer(transitionFrame)

            transitionFrameWrapperView.snp.makeConstraints {
                $0.leading.equalTo(formationFrame.snp.trailing)
                $0.width.equalTo(ViewContants.Constants.trasitionFrame.width)
                $0.height.equalTo(ViewContants.Constants.trasitionFrame.width)
                $0.centerY.equalTo(formationFrame.snp.centerY)
            }
            layoutIfNeeded()
        }
        isCurrentFormation = false
    }

    private func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.width/2,
                                          y: rect.height/2),
                              control: CGPoint(x: rect.width/3,
                                               y: -rect.height/20))
            path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height),
                              control: CGPoint(x: rect.width * 2/3,
                                               y: rect.height * 21/20))

            path.move(to: CGPoint(x: 0, y: rect.height))
            path.addQuadCurve(to: CGPoint(x: rect.width/2,
                                          y: rect.height/2),
                              control: CGPoint(x: rect.width/3,
                                               y: rect.height * 21/20 ))
            path.addQuadCurve(to: CGPoint(x: rect.width, y: 0),
                              control: CGPoint(x: rect.width * 2/3,
                                               y: -rect.height/20))
        }
    }
}
