//
//  PerformanceLoadingView.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import SwiftUI

struct PerformanceLoadingView: View {
    let dependency: PerformanceLoadingViewDependency
    @Binding var path: [PresentType]
    @StateObject private var viewModel = PerformanceLoadingViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                FodiProgressView()
                    .frame(width: 50, height: 50)
                Text("프로젝트 생성중 ...")
                    .foregroundStyle(Color.blueLight3)
            } else {
                Image("loadingFinish")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                Text("프로젝트 생성 완료")
                    .foregroundStyle(Color.blueLight3)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if let performance = viewModel.performance {
                                let dependency = FormationSettingViewDependency(performance: performance)
                                MixpanelManager.shared.track(.tabFinishGenerateProjectBtn(
                                    [
                                        "UID": dependency.performance.fireStoreID,
                                        "Music_Title": dependency.performance.music.title,
                                        "HeadCount": "\(dependency.performance.headcount)"
                                    ]
                                ))
                                path = [.formationSetting(dependency)]
                            }
                        }
                    }
            }
        }
        .background {
            Image("background")
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
        }
        .navigationBarBackButtonHidden()
        .task {
            viewModel.setupWithDependency(dependency)
            await viewModel.executeTask()
            viewModel.endLoading()
        }
    }
}
