//
//  PlayTimer.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import Foundation

class PlayTimer {

    private var timer: Timer?
    var timeInterval: Double
    private var timingAction: () -> Void = {  }

    init(timeInterval: Double) {
        self.timeInterval = timeInterval
    }

    func startTimer(completion: @escaping () -> Void) {
        timingAction = completion
        timingAction()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            timingAction()
        }
    }

    func restartTimer() {
        startTimer(completion: timingAction)
    }

    func stopTimer() {
        timer?.invalidate()
    }

    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}
