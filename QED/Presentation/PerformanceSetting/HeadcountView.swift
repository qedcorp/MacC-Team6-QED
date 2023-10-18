//
//  HeadcountView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct HeadcountView: View {

    @ObservedObject var performancesettingVM: PerformanceSettingViewModel

    var body: some View {
        VStack {
            HStack {
                Text("선택한 음악을\n추는 팀원의 수는?")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
            }
            .padding()
            Spacer()

            ZStack {
                Text("\(performancesettingVM.headcount)")
                    .font(.system(size: 30))
                    .bold()
                    .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .background(
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(.white)
                            .cornerRadius(50)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
                    )
                    .padding()

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
                .padding(.horizontal, 23)
            }

            Spacer()
            NavigationLink {

            }label: {
                nextbutton
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
    HeadcountView()
}
