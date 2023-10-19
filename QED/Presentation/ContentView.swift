// Created by byo.

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("자리표 짜기") {
                    FormationManageView()
                }
                NavigationLink("프리셋 만들기") {
                    PresetManageView()
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
