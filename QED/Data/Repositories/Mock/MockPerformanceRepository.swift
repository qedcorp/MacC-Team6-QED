// Created by byo.

import Foundation

class MockPerformanceRepository: PerformanceRepository {
    private var performances: [Performance] = []

    func createPerformance(_ performance: Performance) async throws -> Performance {
        performances.append(performance)
        return performance
    }

    func readPerformance() async throws -> Performance {
        //        guard let performance = performances.last else {
        //            throw DescribableError(description: "Cannot find a performance.")
        //        }
        //        return performance
        return mockPerformance
    }

    func readPerformances() async throws -> [Performance] {
        //        performances
        return [mockPerformance]
    }

    func updatePerformance(_ performance: Performance) async throws -> Performance {
        performance
    }
}

let info1 = Member.Info(name: "쥬쥬", color: "F06292")
let info2 = Member.Info(name: "웅", color: "85C1E9")
let info3 = Member.Info(name: "키오오", color: "C39BD3")
let info4 = Member.Info(name: "올링링링", color: "F7DC6F")
var members1 = [Member(relativePosition: RelativePosition(x: 100, y: 500),
                       info: info1),
                Member(relativePosition: RelativePosition(x: 300, y: 500),
                       info: info2),
                Member(relativePosition: RelativePosition(x: 500, y: 500),
                       info: info3),
                Member(relativePosition: RelativePosition(x: 700, y: 500),
                       info: info4)]

private var members2 = [Member(relativePosition: RelativePosition(x: 500, y: 200),
                               info: info1),
                        Member(relativePosition: RelativePosition(x: 500, y: 500),
                               info: info2),
                        Member(relativePosition: RelativePosition(x: 500, y: 700),
                               info: info3),
                        Member(relativePosition: RelativePosition(x: 500, y: 900),
                               info: info4)]

private var members3 = [Member(relativePosition: RelativePosition(x: 700, y: 200),
                               info: info1),
                        Member(relativePosition: RelativePosition(x: 700, y: 500),
                               info: info2),
                        Member(relativePosition: RelativePosition(x: 700, y: 700),
                               info: info3),
                        Member(relativePosition: RelativePosition(x: 700, y: 900),
                               info: info4)]

var mockFormations = [Formation(members: members1, startMs: 0, memo: "킥인더도어"),
                      Formation(members: members2, startMs: 130000, memo: "눈 감고 팝팝"),
                      Formation(members: members3, startMs: 135000, memo: "눈 팝팝")]

private struct Youtube: Playable {
    let title: String
    let creator: String
    let thumbnailURL: URL?
}

private var youtube = Youtube(title: "Pink Venom",
                              creator: "Black Pink",
                              thumbnailURL: nil)

var mockPerformance = Performance(author: User(email: "", nickname: ""),
                                  playable: youtube,
                                  headcount: 4,
                                  title: youtube.title,
                                  formations: mockFormations)
