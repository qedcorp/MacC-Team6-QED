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
        performances
        //        return [mockPerformance, mockPerformance1, mockPerformance2, mockPerformance3, mockPerformance4]
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

var mockPerformance = Performance(id: "1231231",
                                  author: User(email: "", nickname: ""),
                                  playable: .newJeans,
                                  headcount: 5,
                                  title: "",
                                  formations: mockFormations)

private struct Youtube: Playable {
    let title: String
    let creator: String
    let thumbnailURL: URL?
}
//
// private var youtube = Youtube(title: "Pink Venom",
//                              creator: "Black Pink",
//                               thumbnailURL: URL(string: "https://i.ibb.co/jfKMZc5/Kakao-Talk-Photo-2023-10-24-02-30-38-005.webp"))
//
// private var youtube1 = Youtube(title: "Super Shy",
//                             creator: "뉴진스",
//                             thumbnailURL: URL(string: "https://i.ibb.co/frZhpP1/Kakao-Talk-Photo-2023-10-24-02-30-38-006.webp"))
//
// private var youtube2 = Youtube(title: "Love Dive",
//                             creator: "IVE",
//                             thumbnailURL: URL(string: "https://i.ibb.co/C8gqrm3/Kakao-Talk-Photo-2023-10-24-02-30-38-004.jpg"))
//
// private var youtube3 = Youtube(title: "Ditto",
//                             creator: "뉴진스",
//                             thumbnailURL: URL(string: "https://i.ibb.co/rZ779Vc/Kakao-Talk-Photo-2023-10-24-02-30-38-003.png"))
//
// private var youtube4 = Youtube(title: "Butter",
//                             creator: "BTS",
//                             thumbnailURL: URL(string: "https://i.ibb.co/Px7S5hf/butter-2-cover.jpg"))
//
// private var youtube5 = Youtube(title: "ETA",
//                             creator: "뉴진스",
//                             thumbnailURL: URL(string: "https://i.ibb.co/HtzF59j/Kakao-Talk-Photo-2023-10-24-02-30-38-001.jpg"))
//
// var mockPerformance = Performance(author: User(email: "", nickname: ""),
//                                          playable: youtube,
//                                          headcount: 4,
//                                          title: youtube.title,
//                                          formations: mockFormations)
//
// var mockPerformance1 = Performance(author: User(email: "", nickname: ""),
//                                         playable: youtube1,
//                                         headcount: 5,
//                                         title: youtube1.title,
//                                         formations: mockFormations)
//
// var mockPerformance2 = Performance(author: User(email: "", nickname: ""),
//                                         playable: youtube2,
//                                         headcount: 5,
//                                         title: youtube2.title,
//                                         formations: mockFormations)
//
// var mockPerformance3 = Performance(author: User(email: "", nickname: ""),
//                                         playable: youtube3,
//                                         headcount: 5,
//                                         title: youtube3.title,
//                                         formations: mockFormations)
//
// var mockPerformance4 = Performance(author: User(email: "", nickname: ""),
//                                         playable: youtube4,
//                                         headcount: 5,
//                                         title: youtube4.title,
//                                         formations: mockFormations)
//
