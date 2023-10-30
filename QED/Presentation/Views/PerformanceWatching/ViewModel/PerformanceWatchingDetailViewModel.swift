//
//  PerformanceWatchingDetailViewModel.swift
//  QED
//
//  Created by kio on 10/23/23.

//

import Foundation

import Combine
import UIKit

class PerformanceWatchingDetailViewModel: ObservableObject {

    var bag = Set<AnyCancellable>()

    var scene: PlayableDanceFormationScene
    var performance: Performance
    private var playTimer: PlayTimer
    @Published var showingFormation: Formation
    @Published var beforeFormation: Formation?
    @Published var isShowingBeforeFormation: Bool = false
    @Published var selectedIndex: Int
    @Published var currentStatus: Status = .pause
    @Published var currentNote: String = ""

    init(performance: Performance) {
        self.scene = PlayableDanceFormationScene()
        scene.size = CGSize(width: 350, height: 220)

        self.performance = performance
        showingFormation = performance.formations.first!
        beforeFormation = performance.formations.first!
        selectedIndex = 0
        currentNote = performance.formations[0].note ?? ""
        playTimer = PlayTimer(timeInterval: 5)

        let danceFormationManager = PlayableDanceFormationManager(scene: scene, formation: mockFormations.first!)
        self.scene.manager = danceFormationManager

        for _ in 0 ..< performance.formations.count - 1 {
            performance.transitions.append(nil)
        }
        subscribe()
    }

    func play() {
        currentStatus = .play
        playTimer.startTimer(completion: timingAction)
    }

    func pause() {
        currentStatus = .pause
        playTimer.resetTimer()
        scene.manager?.fetchNew(formation: showingFormation)
        if isShowingBeforeFormation {
            scene.manager?.fetchNew(formation: beforeFormation!, isPreview: true)
        }
    }

    func backward() {
        if selectedIndex - 1 >= 0 {
            selectedIndex -= 1
        }
    }

    func forward() {
        if selectedIndex + 1 < performance.formations.count {
            selectedIndex += 1
        }
    }

    func selectFormation(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
    }

    func beforeFormationShowingToggle() {
        isShowingBeforeFormation.toggle()
    }

    func saveNote() {
        if performance.formations[selectedIndex].note == nil {
            performance.formations[selectedIndex].note = ""
        }
        performance.formations[selectedIndex].note = currentNote
    }
}

extension PerformanceWatchingDetailViewModel {
    enum Status {
        case play
        case pause
    }

    private func subscribe() {
        $selectedIndex
            .sink { [weak self] index in
                guard let self = self else { return }

                self.showingFormation = self.performance.formations[index]
                if index == performance.formations.count - 1 {
                    currentStatus = .pause
                }
                if  self.isShowingBeforeFormation {
                    self.beforeFormation = self.performance.formations[index]
                    if currentStatus == .play {
                        self.scene.manager?.fetchNew(formation: self.showingFormation, isPreview: true)
                    } else {
                        self.scene.manager?.fetchNew(formation: self.beforeFormation!, isPreview: true)
                    }

                }
                self.scene.manager?.fetchNew(formation: self.showingFormation)
                self.currentStatus = .pause
                self.currentNote = self.performance.formations[index].note ?? ""
            }
            .store(in: &bag)

        $isShowingBeforeFormation
            .sink { [weak self] isShowing in
                guard let self = self else { return }
                if isShowing {
                    self.beforeFormation = self.performance.formations[self.selectedIndex]
                    self.scene.manager?.fetchNew(formation: self.beforeFormation!, isPreview: true)
                } else {
                    self.beforeFormation = nil
                    self.scene.manager?.fetchNew(formation: Formation(), isPreview: true)

                }
            }
            .store(in: &bag)
    }

    private func timingAction() {
        if selectedIndex + 1 < performance.formations.count {
            if let transitions = performance.transitions[selectedIndex] {
                scene.manager?.playPerformance(transion: transitions,
                                               afterFormation: performance.formations[selectedIndex + 1]) { [weak self] in
                    guard let self = self else { return }
                    self.selectedIndex += 1

                }
            } else {
                guard let transitions = makeTransitionWithStraightLine(
                    before: performance.formations[selectedIndex],
                    after: performance.formations[selectedIndex + 1]
                ) else { return }
                scene.manager?.playPerformance(transion: transitions,
                                               afterFormation: performance.formations[selectedIndex + 1]) { [weak self] in
                    guard let self = self else { return }
                    print("@LOG ssssss")
                    self.selectedIndex += 1
                }
            }
        }
    }

    private func makeTransitionWithStraightLine(before: Formation, after: Formation) -> FormationTransition? {
        var result: [Member.Info: Data] = [:]
        let width = scene.frame.width
        let height = scene.frame.height

        for beforeMember in before.members {
            if let aftermember = after.members.first(where: { $0.info == beforeMember.info }) {
                let startPoint = CGPoint(
                    x: width * CGFloat(beforeMember.relativePosition.spriteX) / CGFloat(RelativePosition.maxX),
                    y: height * CGFloat(beforeMember.relativePosition.spriteY) / CGFloat(RelativePosition.maxY)
                )
                let endPoint = CGPoint(
                    x: width * CGFloat(aftermember.relativePosition.spriteX) / CGFloat(RelativePosition.maxX),
                    y: height * CGFloat(aftermember.relativePosition.spriteY) / CGFloat(RelativePosition.maxY)
                )

                var path = UIBezierPath()
                path.move(to: startPoint)
                path.addLine(to: endPoint)

                path.close()
                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: path, requiringSecureCoding: false),
                      let info = beforeMember.info else {
                    return nil
                }
                result[info] = data
            }
        }
        return FormationTransition(memberMovements: result)
    }

}
