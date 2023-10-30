//
//  PerformanceWatchingListViewModel.swift
//  QED
//
//  Created by chaekie on 10/30/23.
//

import Foundation

class PerformanceWatchingListViewModel: ObservableObject {
    var performance: Performance
    @Published var yame = ""

    init(performance: Performance) {
        self.performance = performance
    }

    func delete(index: Int) {
        performance.formations = performance.formations.filter({ $0 != performance.formations[index] })
        yame = UUID().uuidString
    }
}
