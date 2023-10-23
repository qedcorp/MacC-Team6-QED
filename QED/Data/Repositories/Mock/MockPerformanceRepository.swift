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
        return [mockPerformance, mockPerformance1, mockPerformance2, mockPerformance3, mockPerformance4]
    }

    func updatePerformance(_ performance: Performance) async throws -> Performance {
        performance
    }
}

var members1 = [Member(relativePosition: RelativePosition(x: 100, y: 500),
                               info: Member.Info(name: "쥬쥬", color: "F06292")),
                        Member(relativePosition: RelativePosition(x: 300, y: 500),
                               info: Member.Info(name: "웅", color: "85C1E9")),
                        Member(relativePosition: RelativePosition(x: 500, y: 500),
                               info: Member.Info(name: "키오오", color: "C39BD3")),
                        Member(relativePosition: RelativePosition(x: 700, y: 500),
                               info: Member.Info(name: "올링링링", color: "F7DC6F"))]
private var members2 = [Member(relativePosition: RelativePosition(x: 500, y: 200),
                               info: Member.Info(name: "쥬쥬", color: "F06292")),
                        Member(relativePosition: RelativePosition(x: 500, y: 500),
                               info: Member.Info(name: "웅", color: "85C1E9")),
                        Member(relativePosition: RelativePosition(x: 500, y: 700),
                               info: Member.Info(name: "키오오", color: "C39BD3")),
                        Member(relativePosition: RelativePosition(x: 500, y: 900),
                               info: Member.Info(name: "올링링링", color: "F7DC6F"))]

var mockFormations = [Formation(members: members1, startMs: 0, memo: "킥인더도어"),
                          Formation(members: members2, startMs: 130000, memo: "눈 감고 팝팝")]

private struct Youtube: Playable {
    let title: String
    let creator: String
    let thumbnailURL: URL?
}

 private var youtube = Youtube(title: "Pink Venom",
                              creator: "Black Pink",
                               thumbnailURL: URL(string: "https://i.ibb.co/Xy7WvmH/images.jpg"))

private var youtube1 = Youtube(title: "Super Shy",
                             creator: "뉴진스",
                             thumbnailURL: URL(string: "https://i.ibb.co/DK9q87m/image.jpg"))

private var youtube2 = Youtube(title: "UNFORGIVEN",
                             creator: "Le SSERAFIM",
                             thumbnailURL: URL(string: "https://i.ibb.co/YXvvQWX/images.jpg"))

private var youtube3 = Youtube(title: "Ditto",
                             creator: "뉴진스",
                             thumbnailURL: URL(string: "https://i.ibb.co/NrSCkW4/ditto.jpg"))

private var youtube4 = Youtube(title: "Butter",
                             creator: "BTS",
                             thumbnailURL: URL(string: "https://i.ibb.co/Px7S5hf/butter-2-cover.jpg"))

 var mockPerformance = Performance(author: User(email: "", nickname: ""),
                                          playable: youtube,
                                          headcount: 4,
                                          title: youtube.title,
                                          formations: mockFormations)

var mockPerformance1 = Performance(author: User(email: "", nickname: ""),
                                         playable: youtube1,
                                         headcount: 5,
                                         title: youtube1.title,
                                         formations: mockFormations)

var mockPerformance2 = Performance(author: User(email: "", nickname: ""),
                                         playable: youtube2,
                                         headcount: 5,
                                         title: youtube2.title,
                                         formations: mockFormations)

var mockPerformance3 = Performance(author: User(email: "", nickname: ""),
                                         playable: youtube3,
                                         headcount: 5,
                                         title: youtube3.title,
                                         formations: mockFormations)

var mockPerformance4 = Performance(author: User(email: "", nickname: ""),
                                         playable: youtube4,
                                         headcount: 5,
                                         title: youtube4.title,
                                         formations: mockFormations)
