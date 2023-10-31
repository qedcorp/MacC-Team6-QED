//
//  HeadcountView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct HeadcountSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PerformanceSettingViewModel

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
            NavigationLink {
                MusicSetupView(viewModel: viewModel)
            } label: {
                nextbutton
            }
            .disabled(viewModel.inputHeadcount < 2)
        }
        .padding()
        .navigationTitle("인원수 선택")
        .navigationBarTitleDisplayMode(.inline)
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
        Text("\(Int(viewModel.inputHeadcount))")
            .multilineTextAlignment(.center)
            .bold()
            .font(.system(size: 30))
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .foregroundColor(viewModel.inputHeadcount < 2 ? .gray : .black)
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
            viewModel.decrementHeadcount()
        }, label: {
            Circle()
                .frame(width: 50)
                .foregroundColor(viewModel.inputHeadcount < 2
                                  ? Color.gray.opacity(0.05)
                                  : Color.gray.opacity(0.13)
                )
                .overlay(
                    Image(systemName: "minus")
                        .bold()
                            .foregroundColor(viewModel.inputHeadcount < 2
                                         ? Color.black.opacity(0.3)
                                         : Color.black
                                        )
                        .font(.system(size: 20))
                )
        })
        .disabled(viewModel.inputHeadcount == viewModel.range.lowerBound)
    }

    private var plusButton: some View {
        Button(action: {
            viewModel.incrementHeadcount()
        }, label: {
            Circle()
                .frame(width: 50)
                .foregroundColor( viewModel.inputHeadcount == viewModel.range.upperBound
                                  ? Color.gray.opacity(0.05)
                                  : Color.gray.opacity(0.13)
                )
                .overlay(
                    Image(systemName: "plus")
                        .bold()
                        .foregroundColor(viewModel.inputHeadcount == viewModel.range.upperBound
                                         ? Color.black.opacity(0.3)
                                         : Color.black
                                        )
                        .font(.system(size: 20))
                )
        })
    }

    private var slider: some View {
        Slider(value: $viewModel.inputHeadcount, in: 1...13)
            .tint(.green)
            .frame(width: 320)
            .padding()
    }

    private var nextbutton: some View {
        Text("다음")
            .bold()
            .font(.title3)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(viewModel.inputHeadcount < 2
                         ? Color.black.opacity(0.2)
                         : Color.black)
            .cornerRadius(15)
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
                    .bold()
            }
        }
    }
}
