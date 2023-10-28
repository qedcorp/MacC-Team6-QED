// Created by byo.

import Foundation

class MockPerformanceRepository: PerformanceRepository {
    private var performances: [Performance] = []

    func createPerformance(_ performance: Performance) async throws -> Performance {
        performances.append(performance)
        return performance
    }

    func readPerformance() async throws -> Performance {
        guard let performance = performances.last else {
            throw DescribableError(description: "Cannot find a performance.")
        }
        return performance
    }

    func readPerformances() async throws -> [Performance] {
//        performances
        return [mockPerformance, mockPerformance1]
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

var mockPerformances = [mockPerformance, mockPerformance1]

let albumCoverURL = URL(string: "https://i.ibb.co/Px7S5hf/butter-2-cover.jpg")
let albumCoverURL1 = URL(string: "https://i.ibb.co/jfKMZc5/Kakao-Talk-Photo-2023-10-24-02-30-38-005.webp")

var mockPerformance = Performance(id: "1231231",
                                  author: User(email: "", nickname: ""),
                                  playable: Music(id: "", title: "뉴진스", artistName: "Newjeans", albumCoverURL: albumCoverURL),
                                  headcount: 5,
                                  title: "성심여고3반귀요미",
                                  formations: mockFormations
)

var mockPerformance1 = Performance(id: "1313",
                                   author: User(email: "", nickname: ""),
                                   playable: Music(id: "1", title: "뚜두뚜두", artistName: "블랙핑크", albumCoverURL: albumCoverURL1),
                                   headcount: 4,
                                   title: "뚜두뚜두",
                                   formations: mockFormations
)
