//// TitleSettingView.swift
// // QED
//
//  // Created by OLING on 10/18/23.
//
// import SwiftUI
//
// struct TitleSetupView: View {
//     @ObservedObject private var viewModel: PerformanceSettingViewModel
//     @FocusState var isFocused: Bool
//
//    init(performanceUseCase: PerformanceUseCase) {
//        self.viewModel = PerformanceSettingViewModel(performanceUseCase: performanceUseCase)
//    }
//
//    var body: some View {
//        DisclosureGroup(
//            isExpanded: $viewModel.isExpanded,
//            content: {
//                inputTitleTextField
//            },
//            label: {
//                if viewModel.isExpanded {
//                    inputTitleLabelClosed
//                } else {
//                    inputTitleLabelOpen
//                }
//            }
//        )
//        .disclosureGroupBackground()
//    }
//
//     var inputTitleTextField: some View {
//         TextField("입력하세요", text: $viewModel.performanceTitle)
//             .focused($isFocused)
//             .foregroundStyle(Color.monoWhite3)
//             .multilineTextAlignment(.center)
//             .font(.body)
//             .bold()
//             .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
//             .background(
//                 RoundedRectangle(cornerRadius: 10)
//                    .foregroundStyle(viewModel.performanceTitle.isEmpty
//                                     ? Color.monoNormal1
//                                     : Color.blueLight2)
//             )
//             .padding()
//             .tint(Color.blueLight2)
//     }
//
//     var inputTitleLabelClosed: some View {
//         Text("프로젝트 이름을 입력하세요")
//             .foregroundStyle(Color.blueLight3)
//             .font(.title3)
//             .bold()
//             .padding(.horizontal)
//             .padding(.vertical, 20)
//
//     }
//
//     var inputTitleLabelOpen: some View {
//         HStack {
//             Text("프로젝트 이름")
//                 .foregroundStyle(Color.gray)
//             Spacer()
//
//             Text("\(viewModel.performanceTitle)")
//                 .foregroundStyle(Color.gray)
//         }
//         .padding(.horizontal)
//         .padding(.vertical, 20)
//     }
// }
