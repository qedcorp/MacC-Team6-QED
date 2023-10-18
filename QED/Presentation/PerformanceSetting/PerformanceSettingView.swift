//
//  PerformanceSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct Setting {
    var navigationtitle: String
    var subtitle: String
}

enum Settings {
    case titlesetting
    case headcount

    var navigationtitle: String {
        switch self {
        case.titlesetting: return "이름설정"
        case.headcount: return "인원수 선택"
        }
    }
    var subtitle: String {
        switch self {
        case.titlesetting: return "프로젝트 이름"
        case.headcount: return "선택한 음악을\n추는 팀원의 수는?"
        }
    }
}

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
