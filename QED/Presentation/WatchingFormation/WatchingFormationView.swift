//
//  DanceFromationView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct WatchingFormationView: View {
    var performance: Int
    var body: some View {
        Text("자리표 보기 \(performance)")
    }
}

#Preview {
    WatchingFormationView(performance: 1)
}
