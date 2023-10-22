//
//  HeadcountView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

import Combine

struct HeadcountView: View {

    @ObservedObject var performancesettingVM: PerformanceSettingViewModel
    @Environment(\.presentationMode) var presentationMode: Binding
    @FocusState private var isFocusedSearchTextField: Bool

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
                Text("\(Int(performancesettingVM.inputHeadcount))")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 30))
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(.white)
                            .cornerRadius(50)
                            .frame(width: 360)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
                    )

                HStack {
                    Button(action: {
                        performancesettingVM.decrementHeadcount()
                    }, label: {
                        Circle()
                            .frame(width: 50)
                            .foregroundColor(.gray.opacity(0.13))
                            .overlay(
                                Image(systemName: "minus")
                                    .bold()
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
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
                                Image(systemName: "plus")
                                    .bold()
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                            )
                    }
                    )
                }
                .padding(.horizontal, 15)
            }

            Slider(value: $performancesettingVM.inputHeadcount, in: 2...13)
                .tint(.green)
                .frame(width: 300)
                .padding()

            Spacer()

            NavigationLink {
                MusicSettingView(performanceSettingVM: PerformanceSettingViewModel())
                    .navigationTitle("노래 선택")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                nextbutton
            }
        }
        .padding()
        .onTapGesture {
            isFocusedSearchTextField = false
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
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

    var btnBack: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
            }
            .foregroundStyle(.green)
        }
    }
}

#Preview {
    HeadcountView(performancesettingVM: PerformanceSettingViewModel())
}
