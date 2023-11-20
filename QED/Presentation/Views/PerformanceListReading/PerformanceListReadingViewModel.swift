//
//  PerformanceListReadingViewModel.swift
//  QED
//
//  Created by chaekie on 11/15/23.
//

import Combine
import Foundation

@MainActor
class PerformanceListReadingViewModel: ObservableObject {
    let performanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self)
    let toastContainerViewModel: ToastContainerViewModel
    @Published var performances: [PerformanceModel]
    @Published var message: [Message] = []

    init(performances: [Performance],
         toastContainerViewModel: ToastContainerViewModel = .shared
    ) {
        self.performances = performances.map { .build(entity: $0) }
        self.toastContainerViewModel = toastContainerViewModel
    }

    func updatePerformanceTitle(id: String, title: String) {
        Task {
            guard let selectePerformance = performances
                .first(where: { $0.id == id })
                .map({ $0.entity }),
                  let selecteIndex = performances
                .firstIndex(where: { $0.id == id }) else { return }
            selectePerformance.title = title
            try await performanceUseCase.updatePerformance(selectePerformance)
            performances.replaceSubrange(selecteIndex...selecteIndex,
                                         with: [PerformanceModel.build(entity: selectePerformance)])
            toastContainerViewModel.presentMessage("프로젝트 이름이 수정되었습니다")
        }
    }

    func selectDeletion(index: Int, performanceID: String) {
        message = [.confirmation(title: AlertMessage.deletePerformance.title,
                                 body: AlertMessage.deletePerformance.body,
                                 label: AlertMessage.deletePerformance.lebel,
                                 action: { [unowned self] in
            deletePerformance(index: index, performanceID: performanceID)
        })]
    }

    func deletePerformance(index: Int, performanceID: String) {
        Task {
            let deleteResult = try await performanceUseCase.removePerformance(performanceID)
            if deleteResult {
                performances.remove(at: index)
                toastContainerViewModel.presentMessage("프로젝트가 삭제되었습니다")
            }
        }
    }
}