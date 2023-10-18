//
//  HeadcountView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct HeadcountView: View {

    @ObservedObject var performancesettingVM: PerformanceSettingViewModel
    @FocusState var isFocused: Bool

//    let usecase: MockUpSearchMusicUseCase = MockUpSearchMusicUseCase(searchMusicRepository: SearchMusicRepositoryMockUp())

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("선택한 음악을\n추는 팀원의 수는?")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
            }
            .padding()
            Spacer()
                .frame(height: 50)
            ZStack {
                TextField("\(performancesettingVM.headcount)", text: $performancesettingVM.textFieldNum)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 30))
                    .bold()
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(.white)
                            .cornerRadius(50)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
                    )
                    .padding(3)

                HStack {
                    Button(action: {
                        performancesettingVM.decrementHeadcount()
                    }, label: {
                        Circle()
                            .frame(width: 50)
                            .foregroundColor(.gray.opacity(0.13))
                            .overlay(
                                Text("-")
                                    .foregroundColor(.black)
                                    .font(.system(size: 40))
                            )
                    })
                    Spacer()

                    Button(action: {
                        performancesettingVM.incrementHeadcount()
                    }, label: {
                        Circle()
                            .frame(width: 50)
                            .foregroundColor(.gray.opacity(0.13))
                            .overlay(
                                Text("+")
                                    .foregroundColor(.black)
                                    .font(.system(size: 40))
                            )
                    })
                }
                .padding(.horizontal, 15)
            }

            Spacer()
            NavigationLink {

            }label: {
                nextbutton
            }
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
        }
    }

    var nextbutton: some View {
        Text("다음")
            .frame(width: 360, height: 54)
            .font(
                Font.custom("Apple SD Gothic Neo", size: 16)
                    .weight(.bold)
            )
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(14)
    }
}

#Preview {
    HeadcountView(performancesettingVM: PerformanceSettingViewModel())
}
