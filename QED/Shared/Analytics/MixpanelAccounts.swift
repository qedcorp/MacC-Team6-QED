//
//  MixpanelAccounts.swift
//  QED
//
//  Created by changgyo seo on 1/15/24.
//

import Mixpanel

enum MixpanelAccounts {
    // 유저당 완성된 자리표 갯수
    case signInCompleted

    case tabGenerateProjectBtn
    case tabSomePerformance // 1
    case tabProfileBtn

    case tabFinishGenerateProjectBtn([String: String]) // uid, 노래제목, 인원수
    case makeProject([String: String])
    // 목적 한 프로젝트 10대형찍었 이중 몇개가 프리셋사용 0번인지 한번 이상인지
    // 가사입력 여부 하나라도 입력하면 true
    case tabSetMemberBtn
    case tabFinishPerformanceBtn

    case watchPerformance([String: String]) // 2
    // 얘가 어떻게 들어오나
    // 상세보기 누르나 안누르나

    var event: String {
        switch self {
        case .signInCompleted:
            return "signInCompleted"
        case .tabGenerateProjectBtn:
            return "tabGenerateProjectBtn"
        case .tabSomePerformance:
            return "tabSomePerformance"
        case .tabProfileBtn:
            return "tabProfileBtn"
        case .tabFinishGenerateProjectBtn:
            return "tabFinishGenerateProjectBtn"
        case .makeProject:
            return "makeProject"
        case .tabSetMemberBtn:
            return "tabSetMemberBtn"
        case .tabFinishPerformanceBtn:
            return "tabFinishPerformanceBtn"
        case .watchPerformance:
            return "watchPerformance"
        }
    }
//    
//    func properties()
//    
//    var properties: [String: String] {
//        switch self {
//        case .tabFinishGenerateProjectBtn(_):
//            return []
//        case .makeProject(_):
//            return
//        case .watchPerformance(_):
//            return
//        default:
//            return [:]
//        }
//    }
}
