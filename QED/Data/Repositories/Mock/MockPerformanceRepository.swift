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
        return performances
    }

    func updatePerformance(_ performance: Performance) async throws -> Performance {
        performance
    }
}

let info1 = Member.Info(name: "쥬쥬", color: "F06292")
let info2 = Member.Info(name: "웅", color: "85C1E9")
let info3 = Member.Info(name: "키오오", color: "C39BD3")
let info4 = Member.Info(name: "올링링링", color: "F7DC6F")
var members1 = [Member(relativePosition: .buildRandom(),
                       info: info1),
                Member(relativePosition: .buildRandom(),
                       info: info2),
                Member(relativePosition: .buildRandom(),
                       info: info3),
                Member(relativePosition: .buildRandom(),
                       info: info4)]

private var members2 = [Member(relativePosition: .buildRandom(),
                               info: info1),
                        Member(relativePosition: .buildRandom(),
                               info: info2),
                        Member(relativePosition: .buildRandom(),
                               info: info3),
                        Member(relativePosition: .buildRandom(),
                               info: info4)]

private var members3 = [Member(relativePosition: .buildRandom(),
                               info: info1),
                        Member(relativePosition: .buildRandom(),
                               info: info2),
                        Member(relativePosition: .buildRandom(),
                               info: info3),
                        Member(relativePosition: .buildRandom(),
                               info: info4)]

private var members4 = [Member(relativePosition: .buildRandom(),
                               info: info1),
                        Member(relativePosition: .buildRandom(),
                               info: info2),
                        Member(relativePosition: .buildRandom(),
                               info: info3),
                        Member(relativePosition: .buildRandom(),
                               info: info4)]

var mockFormations = [Formation(members: members1, startMs: 0, memo: "암슈퍼샤이", note: "키오 기어가기"),
                      Formation(members: members2, startMs: 130000, memo: "떨리는 지금도"),
                      Formation(members: members3, startMs: 135000, memo: "암슈퍼샤이", note: "지니 돌아가기"),
                      Formation(members: members4, startMs: 140000, memo: "가나다라", note: "지니 움직이고 쥬쥬 움직이기")]

let albumCoverURL = URL(string: "https://i.ibb.co/Px7S5hf/butter-2-cover.jpg")
let albumCoverURL1 = URL(string: "https://i.ibb.co/jfKMZc5/Kakao-Talk-Photo-2023-10-24-02-30-38-005.webp")

private var music1 = Music(id: "ert",
                           title: "Pink Venom",
                           artistName: "블랙핑크(Black Pink)",
                           albumCoverURL: URL(string: "https://i.ibb.co/jfKMZc5/Kakao-Talk-Photo-2023-10-24-02-30-38-005.webp"))

private var music2 = Music(id: "ert",
                           title: "Super Shy",
                           artistName: "뉴진스(NewJeans)",
                           albumCoverURL: URL(string: "https://i.ibb.co/frZhpP1/Kakao-Talk-Photo-2023-10-24-02-30-38-006.webp"))

private var music3 = Music(id: "ert",
                           title: "Love Dive",
                           artistName: "아이브(IVE)",
                           albumCoverURL: URL(string: "https://i.ibb.co/C8gqrm3/Kakao-Talk-Photo-2023-10-24-02-30-38-004.jpg"))

private var music4 = Music(id: "ert",
                           title: "Ditto",
                           artistName: "뉴진스(NewJeans)",
                           albumCoverURL: URL(string: "https://i.ibb.co/rZ779Vc/Kakao-Talk-Photo-2023-10-24-02-30-38-003.png"))

private var music5 = Music(id: "ert",
                           title: "Butter",
                           artistName: "방탄소년단(BTS)",
                           albumCoverURL: URL(string: "https://i.ibb.co/Px7S5hf/butter-2-cover.jpg"))

private var music6 = Music(id: "ert",
                           title: "ETA",
                           artistName: "뉴진스(NewJeans)",
                           albumCoverURL: URL(string: "https://i.ibb.co/HtzF59j/Kakao-Talk-Photo-2023-10-24-02-30-38-001.jpg"))

var mockPerformance1 = Performance(id: "ggg",
                                   author: User(email: "", nickname: "포디"),
                                   music: music1,
                                   headcount: 4,
                                   title: music1.title,
                                   formations: mockFormations)

var mockPerformance2 = Performance(id: "ghg",
                                   author: User(email: "", nickname: "포디"),
                                   music: music2,
                                   headcount: 5,
                                   title: music2.title,
                                   formations: mockFormations)

var mockPerformance3 = Performance(id: "qgg",
                                   author: User(email: "", nickname: "포디"),
                                   music: music3,
                                   headcount: 6,
                                   title: music3.title,
                                   formations: mockFormations)

var mockPerformance4 = Performance(id: "ggo",
                                   author: User(email: "", nickname: "포디"),
                                   music: music4,
                                   headcount: 5,
                                   title: music4.title,
                                   formations: mockFormations)

var mockPerformance5 = Performance(id: "gxg",
                                   author: User(email: "", nickname: "포디"),
                                   music: music5,
                                   headcount: 7,
                                   title: music5.title,
                                   formations: mockFormations)

var mockPerformance6 = Performance(id: "gng",
                                   author: User(email: "", nickname: "포디"),
                                   music: music6,
                                   headcount: 5,
                                   title: music6.title,
                                   formations: mockFormations)
