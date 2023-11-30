// Created by byo.

import Combine
import Foundation

@MainActor
class ToastContainerViewModel: ObservableObject {
    static let shared = ToastContainerViewModel()
    private static let schedulerInterval = 0.1

    @Published private(set) var currentMessage: String?
    @Published private var remainingMs = 0
    private var cancellables: Set<AnyCancellable> = []

    private init() {
        setupScheduler()
    }

    var isMessagePresentable: Bool {
        remainingMs > 0
    }

    private func setupScheduler() {
        Timer.scheduledTimer(withTimeInterval: Self.schedulerInterval, repeats: true) { _ in
            DispatchQueue.main.async { [unowned self] in
                reduceRemainingMs()
            }
        }
    }

    private func reduceRemainingMs() {
        guard remainingMs > 0 else {
            return
        }
        animate {
            remainingMs = max(Int(Double(remainingMs) - Self.schedulerInterval * 1000), 0)
            if remainingMs == 0 {
                currentMessage = nil
            }
        }
    }

    func presentMessage(_ message: String, durationMs: Int = 1500) {
        animate {
            currentMessage = message
            remainingMs = durationMs
        }
    }
}
