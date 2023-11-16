//
//  PerformanceLoadingView.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import SwiftUI

struct PerformanceLoadingView: View {
    let transfer: PerformanceLoadingTransferModel
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
                                path = [.formationSetting(performance)]
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
            viewModel.transfer = transfer
            await viewModel.executeTask()
            viewModel.endLoading()
        }
    }
}
