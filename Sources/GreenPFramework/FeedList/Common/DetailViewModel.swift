//
//  DetailViewModel.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/18.
//

import UIKit

class DetailViewModel {
    var feed: FeedList.Feed? {
        didSet {
            participateIn()
        }
    }
    var onSuccessReturnParticipateURL: ((ParticipateInfo) -> Void)?
    var onFailureReturnParticipateURL: ((String) -> Void)?
    var shouldDeleteRowOnFailureParticipate: (() -> Void)?

    init() {}
    
    convenience init(feed: FeedList.Feed) {
        self.init()
        self.feed = feed
    }
    
    func sendImpressionCount() {
        if feed?.category != "CPA" { return }
        guard let feedID = feed?.id else {
            return
        }
        Task {
            do {
                let _: APIResult = try await NetworkManager.shared.request(subURL: "sdk/imp.html?appcode=\(UserInfo.shared.appCode ?? "")&ads_idx=\(feedID)", method: .get)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func participateIn() {
        guard let feedID = feed?.id else {
            return
        }
        let param = ParticipateParam(id: feedID)

        Task {
            do {
                let result: ParticipateInfo = try await NetworkManager.shared.request(subURL: "sdk/ads_join.html", params: param.dictionary, method: .get)
                if result.result == "S", let _ = URL(string: result.url) {
                    onSuccessReturnParticipateURL?(result)
                } else {
                    if result.result == "-201" {
                        shouldDeleteRowOnFailureParticipate?()
                    }
                    onFailureReturnParticipateURL?(result.message.isEmpty ? "Invalidate URL address!" : result.message)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
