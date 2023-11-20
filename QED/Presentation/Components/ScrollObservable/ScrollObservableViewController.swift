//
//  ScrollObservableViewController.swift
//  QED
//
//  Created by changgyo seo on 11/6/23.
//

import UIKit

import Combine
import SnapKit
import SwiftUI

final class ScrollObservableViewController: UIViewController {

    typealias ValuePurpose = ScrollObservableView.ValuePurpose
    typealias Constants = ScrollObservableView.Constants

    private var bag = Set<AnyCancellable>()

    var action: CurrentValueSubject<ValuePurpose, Never>

    var offset: CGFloat = 0.0
    // TODO: 이거 맞냐???
    private var initYame = true
    private var performance: Performance
    private var indexToStartOffset: [Int: CGFloat] = [:]
    private var offSetToIndex: [Range<CGFloat>: Int] = [:]
    private var baseOffset: CGFloat = 0
    private var currentIndex: Int = 0 {
        didSet {
            for index in 0..<performance.formations.count {
                let indexPath = IndexPath(row: index, section: 0)
                guard let cell = collectionView.cellForItem(at: indexPath) as? ScrollObservableCollectionViewCell else { continue }
                if index == currentIndex {
                    cell.changeColorWithSelection(true)
                } else {
                    cell.changeColorWithSelection(false)
                }
            }
        }
    }

    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(
            width: Constants.formationFrame.width + Constants.trasitionFrame.width,
            height: Constants.playBarHeight
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    var currentBar: UIImageView = {
        let uiImageView = UIImageView()

        let uiImage = UIImage(named: "Union")
        uiImageView.image = uiImage
        uiImageView.contentMode = .scaleAspectFit

        return uiImageView
    }()

    init(performance: Performance, action: CurrentValueSubject<ValuePurpose, Never>) {
        self.action = action
        self.performance = performance
        super.init(nibName: nil, bundle: nil)
        binding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setCollectionView()
    }

    func binding() {
        action
            .sink { [weak self] purpose in
                guard let self = self else { return }
                switch purpose {
                case let .setOffset(offset):
                    self.setCollectionViewOffset(offset)
                case let .setSelctedIndex(index):
                    self.currentIndex = index
                default:
                    break
                }
            }
            .store(in: &bag)

    }

    private func moveToIndex(_ index: Int) {
        var point = collectionView.contentOffset
        point.x = (indexToStartOffset[index] ?? 100) + 1
        collectionView.setContentOffset(point, animated: true)
    }

    private func setCollectionViewOffset(_ offset: CGFloat, withAnimation: Bool = false) {
        if !withAnimation {
            collectionView.contentOffset.x = offset
        } else {
            var point = collectionView.contentOffset
            point.x = offset
            collectionView.setContentOffset(point, animated: true)
        }
    }

    private func layout() {
        [collectionView, currentBar].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }

        currentBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-6)
            $0.centerX.bottom.equalToSuperview()
        }
    }

    private func setCollectionView() {
        collectionView.register(
            ScrollObservableCollectionViewCell.self,
            forCellWithReuseIdentifier: ScrollObservableCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ScrollObservableViewController: UICollectionViewDataSource,
                                          UICollectionViewDelegate,
                                          UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0, left: view.frame.width / 2,
            bottom: 0, right: view.frame.width / 2 - Constants.trasitionFrame.width
        )
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return performance.formations.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScrollObservableCollectionViewCell.identifier,
            for: indexPath
        ) as? ScrollObservableCollectionViewCell else { return UICollectionViewCell() }

        if indexPath.row == performance.formations.count - 1 {
            cell.hasTransition = false
        }
        cell.index = indexPath.row + 1
        cell.formation = performance.formations[indexPath.row]

        if indexPath.row == currentIndex {
            cell.isCurrentFormation = true
        }
        if indexPath.row == 0 { baseOffset = cell.frame.origin.x }
        let startX = cell.frame.origin.x - baseOffset
        let endX = startX + cell.frame.size.width
        indexToStartOffset[indexPath.row] = startX
        offSetToIndex[startX..<endX] = indexPath.row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToIndex(indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !initYame {
            action.send(.getOffset(scrollView.contentOffset.x))
            if let index = offSetToIndex[scrollView.contentOffset.x] {
                if index != currentIndex {
                    currentIndex = index
                }
            }
        }
        initYame = false
    }
}
