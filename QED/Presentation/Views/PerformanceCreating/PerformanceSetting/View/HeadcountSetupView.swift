////
////  HeadcountView.swift
////  QED
////
////  Created by OLING on 10/18/23.
////
//
// import SwiftUI
//
// struct HeadcountSetupView: View {
//     @ObservedObject private var viewModel: PerformanceSettingViewModel
//     @Environment(\.dismiss) private var dismiss
//     @FocusState var isFocused: Bool
//
//     init(performanceUseCase: PerformanceUseCase) {
//         self.viewModel = PerformanceSettingViewModel(performanceUseCase: performanceUseCase)
//     }
//
//    var body: some View {
//        DisclosureGroup(
//            isExpanded: $viewModel.isExpanded2,
//            content: {
//                VStack {
//                    ZStack {
//                        inputHeadcountTextField
//                        HStack {
//                            Button {
//                                viewModel.decrementHeadcount()
//                            } label: {
//                                Image("minus_on")
//                            }
//                            Spacer()
//                            Button {
//                                viewModel.incrementHeadcount()
//                            } label: {
//                                Image("plus_on")
//                            }
//                        }
//                        .padding(.vertical)
//                    }
//                    .padding(.horizontal)
//                    slider
//                    headcountText
//                    inputMemperinfoTextFiledsView
//                }
//            },
//
//            label: {
//                if viewModel.isExpanded2 {
//                    Text("인원수를 입력하세요")
//                        .foregroundStyle(Color.blueLight3)
//                        .font(.title3)
//                        .bold()
//                        .padding(.horizontal)
//                        .padding(.vertical, 20)
//
//                } else {
//                    HStack {
//                        Text("인원 수")
//                            .foregroundStyle(Color.gray)
//                        Spacer()
//
//                        Text("performaceinputheadcount")
//                            .foregroundStyle(Color.gray)
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 20)
//                }
//            }
//        )
//        .disclosureGroupBackground()
//    }
//
//     var inputHeadcountTextField: some View {
//         Text("\(viewModel.headcount)")
//             .multilineTextAlignment(.center)
//             .font(.title2)
//             .bold()
//             .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
//             .foregroundColor(viewModel.headcount < 2 ? .gray : .black)
//             .background(
//                 RoundedRectangle(cornerRadius: 20)
//                     .foregroundStyle(Color.monoNormal1)
//                     .frame(width: 310)
//             )
//             .tint(Color.blueLight2)
//
//     }
//     var headcountText: some View {
//         Text("이름을 입력해서 동선을 확인할 수 있어요")
//             .foregroundStyle(Color.monoWhite2)
//             .font(.subheadline)
//     }
//
//     var slider: some View {
//         Slider(
//             value: .init(
//                 get: { Double(viewModel.headcount) },
//                 set: { viewModel.headcount = Int($0) }
//             ),
//             in: 0 ... 13,
//             step: 1
//         )
//         .tint(Color.blueLight3)
//         .frame(width: 320)
//         .onChange(of: viewModel.headcount) { newValue in
//             viewModel.updateHeadcount(newCount: Int(newValue))
//         }
//     }
//
//     var inputMemperinfoTextFiledsView: some View {
//         let textFieldsConut = viewModel.inputMemberInfo.count
//
//         if viewModel.headcount > textFieldsConut {
//             viewModel.updateHeadcount(newCount: viewModel.headcount)
//         } else if viewModel.headcount < textFieldsConut {
//             viewModel.inputMemberInfo.removeLast()
//         }
//         return VStack {
//             TextField("인원 1", text: $viewModel.inputMemberDefault)
//                 .focused($isFocused)
//                 .foregroundStyle(Color.monoNormal2)
//                 .multilineTextAlignment(.center)
//                 .font(.headline)
//                 .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//                 .background(
//                     RoundedRectangle(cornerRadius: 10)
//                         .foregroundStyle(viewModel.inputMemberDefault.isEmpty
//                                          ? Color.monoNormal1
//                                          : Color.blueLight2)
//                 )
//                 .padding(.horizontal)
//                 .padding(.vertical, 3)
//                 .tint(Color.blueLight2)
//
//             ForEach(0..<viewModel.inputMemberInfo.count, id: \.self) { index in
//                 TextField("인원 \(index + 2)", text: $viewModel.inputMemberInfo[index])
//                     .focused($isFocused)
//                     .foregroundStyle(Color.monoNormal2)
//                     .multilineTextAlignment(.center)
//                     .font(.headline)
//                     .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//                     .background(
//                         RoundedRectangle(cornerRadius: 10)
//                             .foregroundStyle(viewModel.inputMemberInfo[index].isEmpty
//                                              ? Color.monoNormal1
//                                              : Color.blueLight2)
//                     )
//                     .padding(.horizontal)
//                     .padding(.vertical, 3)
//                     .tint(Color.blueLight2)
//
//                 Spacer()
//
//             }
//         }
//     }
//
// }
