//
//  MyPageView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct MyPageView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Image("MockLogo")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.8)

            Text("포딩이 프로필")
                .font(.title)
                .fontWeight(.heavy)
                .kerning(0.36)
                .foregroundStyle(Color(red: 0.45, green: 0.87, blue: 0.98))
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.45, green: 0.87, blue: 0.98))
                }
            }
        }
    }
}

#Preview {
    MyPageView()
}
