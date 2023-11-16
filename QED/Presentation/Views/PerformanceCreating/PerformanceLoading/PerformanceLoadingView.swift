//
//  PerformanceLoadingView.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import SwiftUI

struct PerformanceLoadingView: View {

    @State var isLoading: Bool = true

    var viewModel: PerformanceSettingViewModel
    @Binding var path: [PresentType]

    var body: some View {
        VStack {
            if isLoading {
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
                            path = [.formationSetting(viewModel.performance!)]
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
            await viewModel.generatePerformance()
            self.isLoading = false
        }
    }
}
