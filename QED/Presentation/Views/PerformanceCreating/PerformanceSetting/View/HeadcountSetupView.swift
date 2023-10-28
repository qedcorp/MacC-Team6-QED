//
//  HeadcountView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct HeadcountSetupView: View {

    @ObservedObject var performancesettingVM: PerformanceSettingViewModel
    @Environment(\.presentationMode) var presentationMode: Binding

    var body: some View {
        VStack {
            Spacer()
            header
            Spacer()
                .frame(height: 50)
            ZStack {
                headcountfield
                HStack {
                    minusButton
                    Spacer()
                    plusButton
                }
                .padding(.horizontal, 15)
            }
            slider
            Spacer()
            next
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            leftItem
        }
    }

    private var header: some View {
        HStack {
            Text("선택한 음악을\n추는 팀원의 수는?")
                .font(.system(size: 30))
                .bold()
            Spacer()
        }
        .padding()
    }

    private var headcountfield: some View {
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
    }

    private var minusButton: some View {
        Button(action: {
            performancesettingVM.decrementHeadcount()
        }, label: {
            Circle()
                .frame(width: 50)
                .foregroundColor(performancesettingVM.inputHeadcount < 2
                                  ? Color.gray.opacity(0.05)
                                  : Color.gray.opacity(0.13)
                )
                .overlay(
                    Image(systemName: "minus")
                        .bold()
                            .foregroundColor(performancesettingVM.inputHeadcount < 2
                                         ? Color.black.opacity(0.3)
                                         : Color.black
                                        )
                        .font(.system(size: 20))
                )
        })
        .disabled(performancesettingVM.inputHeadcount == performancesettingVM.range.lowerBound)
    }

    private var plusButton: some View {
        Button(action: {
            performancesettingVM.incrementHeadcount()
        }, label: {
            Circle()
                .frame(width: 50)
                .foregroundColor( performancesettingVM.inputHeadcount == performancesettingVM.range.upperBound
                                  ? Color.gray.opacity(0.05)
                                  : Color.gray.opacity(0.13)
                )
                .overlay(
                    Image(systemName: "plus")
                        .bold()
                        .foregroundColor(performancesettingVM.inputHeadcount == performancesettingVM.range.upperBound
                                         ? Color.black.opacity(0.3)
                                         : Color.black
                                        )
                        .font(.system(size: 20))
                )
        })
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink(destination: MainView()) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
                    .bold()
            }
        }
    }

    private var slider: some View {
        Slider(value: $performancesettingVM.inputHeadcount, in: 0...13)
            .tint(.green)
            .frame(width: 320)
            .padding()
    }

    private var next: some View {
        NavigationLink {
            MusicSetupView(performanceSettingVM: PerformanceSettingViewModel())
                .navigationTitle("노래 선택")
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            nextbutton
        }
    }
    private var nextbutton: some View {
        Text("다음")
            .frame(width: 340, height: 54)
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
    HeadcountSetupView(performancesettingVM: PerformanceSettingViewModel())
}
