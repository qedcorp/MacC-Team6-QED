//
//  DetailFormationViewModel.swift
//  QED
//
//  Created by kio on 10/23/23.

//

import Foundation

import Combine
import UIKit

class DetailFormationViewModel: ObservableObject {

    var bag = Set<AnyCancellable>()

    var scene: DanceFormationScene
    var performance: Performance
    private var playTimer: PlayTimer
    @Published var showingFormation: Formation
    @Published var beforeFormation: Formation?
    @Published var isShowingBeforeFormation: Bool = false
    @Published var selectedIndex: Int
    @Published var currentStatus: Status = .pause
    @Published var currentNote: String = ""

    init() {
        self.scene = DanceFormationScene()
        scene.size = CGSize(width: 350, height: 220)

        performance = mockPerformance
        showingFormation = performance.formations.first!
        beforeFormation = nil
        selectedIndex = 0
        playTimer = PlayTimer(timeInterval: 7)

        let danceFormationManager = DanceFormationManager(scene: scene, formation: mockFormations.first!)
        self.scene.manager = danceFormationManager

        for _ in 0 ..< performance.formations.count - 1 {
            performance.transitions.append(nil)
        }
        subscribe()
    }

    func play() {
        playTimer.startTimer(completion: timingAction)
    }

    func pause() {
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
        if performance.formations[selectedIndex].notes == nil {
            performance.formations[selectedIndex].notes = []
        }
        performance.formations[selectedIndex].notes?.append(currentNote)
    }
}

extension DetailFormationViewModel {
    enum Status {
        case play
        case pause
    }

    private func subscribe() {
        $selectedIndex
            .sink { [weak self] index in
                guard let self = self else { return }

                self.showingFormation = self.performance.formations[index]
                self.scene.manager?.fetchNew(formation: self.showingFormation)
                if self.isShowingBeforeFormation && index - 1 >= 0 {
                    self.beforeFormation = self.performance.formations[index - 1]
                }
                self.currentStatus = .pause
                self.currentNote = ""
            }
            .store(in: &bag)

        $isShowingBeforeFormation
            .sink { [weak self] isShowing in
                guard let self = self else { return }
                if isShowing {
                    if self.selectedIndex - 1 >= 0 {
                        self.beforeFormation = self.performance.formations[self.selectedIndex - 1]
                        self.scene.manager?.fetchNew(formation: self.beforeFormation!, isPreview: true)
                    }
                } else {
                    self.beforeFormation = nil
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
                    selectedIndex += 1

                }
            } else {
                guard let transitions = makeTransitionWithStraightLine(
                    before: performance.formations[selectedIndex],
                    after: performance.formations[selectedIndex + 1]
                ) else { return }
                scene.manager?.playPerformance(transion: transitions,
                                               afterFormation: performance.formations[selectedIndex + 1]) { [weak self] in
                    guard let self = self else { return }
                    selectedIndex += 1
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
