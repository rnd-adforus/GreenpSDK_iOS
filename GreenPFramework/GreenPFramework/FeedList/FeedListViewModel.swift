//
//  FeedListViewModel.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/15.
//

import UIKit

class FeedListViewModel {
    private let TAG_KEY_ALL = "All"
    
    var tabIndex: Int = 0
    var selectedTag: String?
    
    var tags: [SettingsData.Data.Tab.Filter] = [] {
        didSet {
            feedList = [FeedInfo(key: TAG_KEY_ALL)] + tags.map{ FeedInfo(key: $0.key) }
            onSuccessLoadCategories?(tags)
        }
    }
    var feedList: [FeedInfo] = []
    
    var onSuccessLoadCategories: (([SettingsData.Data.Tab.Filter]) -> Void)?
    var onSuccessLoadFeedList: (([FeedCellConfig]) -> Void)?
    var onNeedReloadFeedList: (([FeedCellConfig]) -> Void)?
    var onFailLoadFeedNoMorePage: (() -> Void)?
    var onShouldMoveDetailView: ((FeedList.Feed) -> Void)?
    var onShouldMoveNewsDetailView: ((FeedList.Feed) -> Void)?
    
    private var isLoading: Bool = false
    
    init() {
    }
    
    func load() {
        if feedList.isEmpty == false { return }
        tags = UserInfo.shared.tabs[tabIndex].filterList
        getFeedList(completion: onNeedReloadFeedList)
    }
    
    func loadNextPage() {
        getFeedList(completion: onSuccessLoadFeedList)
    }
    
    func getFeedList(completion: (([FeedCellConfig]) -> Void)?) {
        let tagKey = selectedTag ?? TAG_KEY_ALL
        guard let list = feedList.filter({ $0.key == tagKey }).first else {
            return
        }
        if list.lastPageDidLoad {
            onFailLoadFeedNoMorePage?()
            return
        }
        
        let category = UserInfo.shared.tabs[tabIndex].key
        let page = list.feeds.count / FEED_PAGE_LIMIT + 1
        let param = FeedListParam(category: category, filterKey: selectedTag, page: page, limit: FEED_PAGE_LIMIT)
        if isLoading { return }
        Task {
            do {
                isLoading = true
                let result: FeedList = try await NetworkManager.shared.request(subURL: "sdk/ads_list_new.html", params: param.dictionary, method: .get)
                isLoading = false
                let configs = saveAndConvert(newFeeds: result.data, tag: tagKey)
                if let completion = completion {
                    completion(configs)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        @Sendable func saveAndConvert(newFeeds: [FeedList.Feed], tag: String) -> [FeedCellConfig] {
            let newConfigs = createCellConfigs(from: newFeeds)
            for (i, list) in feedList.enumerated() {
                if list.key == tag {
                    feedList[i].feeds += newFeeds
                    feedList[i].cellConfigs += newConfigs
                    feedList[i].lastPageDidLoad = newFeeds.count < FEED_PAGE_LIMIT
                }
            }
            return newConfigs
        }
    }
    
    private func createCellConfigs(from feeds: [FeedList.Feed]) -> [FeedCellConfig] {
        let configs = feeds.map{ feed in
            let subMenuTitle = UserInfo.shared.filters[tabIndex][feed.subMenuValue]
            return FeedCellConfig(feed: feed, subMenuTitle: subMenuTitle)
        }
        return configs
    }
    
    // MARK: Actions
    
    func changeTag(key: String) {
        if key == "0" {
            // 전체 탭
            selectedTag = nil
            onNeedReloadFeedList?(feedList.filter{ $0.key == TAG_KEY_ALL }.first?.cellConfigs ?? [])
        } else {
            selectedTag = key
            let loadedCellConfigs = feedList.filter{ $0.key == key }.first?.cellConfigs ?? []
            if loadedCellConfigs.count == 0 {
                getFeedList(completion: onNeedReloadFeedList)
            } else {
                onNeedReloadFeedList?(loadedCellConfigs)
            }
        }
    }
    
    func selectRow(at indexPath: IndexPath) {
        guard let feedList = feedList.filter({ $0.key == selectedTag ?? TAG_KEY_ALL }).first?.feeds else {
            return
        }
        
        let feed = feedList[indexPath.row]
        if feed.category == "NEWS" {
            onShouldMoveNewsDetailView?(feed)
        } else {
            onShouldMoveDetailView?(feed)
        }
    }
}
