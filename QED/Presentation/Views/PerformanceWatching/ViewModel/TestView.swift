//
//  TestView.swift
//  QED
//
//  Created by changgyo seo on 11/5/23.
//

import SwiftUI

struct TestView: View {

    @ObservedObject var vm = NewViewModel(performance: mockPerformance1)

    var body: some View {
        VStack {
            Text("")
//            ObjectPlayableView(movementsMap: MovementsMap, index: <#T##Binding<Int>#>)
        }
    }
}
