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
            do {
                try await performanceUseCase.updatePerformance(selectePerformance)
                performances.replaceSubrange(selecteIndex...selecteIndex,
                                             with: [PerformanceModel.build(entity: selectePerformance)])
                toastContainerViewModel.presentMessage("프로젝트 이름이 수정되었습니다")
            } catch {
                toastContainerViewModel.presentMessage("프로젝트 수정에 실패했습니다")
            }
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
            do {
                if !performanceID.isEmpty {
                    let deleteResult = try await performanceUseCase.removePerformance(performanceID)
                    if deleteResult {
                        performances.removeAll { $0.entity.id == performanceID }
                        toastContainerViewModel.presentMessage("프로젝트가 삭제되었습니다")
                    }
                }
            } catch {
                toastContainerViewModel.presentMessage("프로젝트 삭제에 실패했습니다")
            }
        }
    }
}
