//
//  PerformanceSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct PerformanceSettingView: View {
    @State var textFieldText: String = ""
    var body: some View {
        NavigationView {
            TitleSettingView(performancesettingVM: PerformanceSettingViewModel())
                .navigationTitle("이름 설정")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
        }
    }
}
#Preview {
    PerformanceSettingView()
}
