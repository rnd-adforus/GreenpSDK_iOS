//
//  FeedListViewModel.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/15.
//

import UIKit

class FeedListViewModel {
    var tabIndex: Int = 0
    var selectedTag: String?
    
    var tags: [SettingsData.Data.Tab.Filter] = [] {
        didSet {
            onSuccessLoadCategories?(tags)
        }
    }
    var feeds: [FeedList.Feed] = []
    var feedCellConfigs: [FeedCellConfig] = []
    
    var filteredFeeds:  [FeedList.Feed] = []
    var filteredCellConfigs: [FeedCellConfig] = []
    
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
        if feeds.isEmpty == false { return }
        tags = UserInfo.shared.tabs[tabIndex].filterList
        getFeedList(completion: onNeedReloadFeedList)
    }
    
    func loadNextPage() {
        getFeedList(completion: onSuccessLoadFeedList)
    }
    
    func getFeedList(completion: (([FeedCellConfig]) -> Void)?) {
        let existCount: Int = selectedTag == nil ? feeds.count : filteredFeeds.count
        if existCount % FEED_PAGE_LIMIT != 0 {
            onFailLoadFeedNoMorePage?()
            return
        }
        
        let page = existCount / FEED_PAGE_LIMIT + 1
        let category = UserInfo.shared.tabs[tabIndex].key
        let param = FeedListParam(category: category, filterKey: selectedTag, page: page, limit: FEED_PAGE_LIMIT)
        if isLoading { return }
        Task {
            do {
                isLoading = true
                let result: FeedList = try await NetworkManager.shared.request(subURL: "sdk/ads_list_new.html", params: param.dictionary, method: .get)
                isLoading = false
                let configs = saveAndConvert(newFeeds: result.data, tag: selectedTag)
                if let completion = completion {
                    completion(configs)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        @Sendable func saveAndConvert(newFeeds: [FeedList.Feed], tag: String? = nil) -> [FeedCellConfig] {
            let newConfigs = createCellConfigs(from: newFeeds)
            if tag == nil {
                self.feeds.append(contentsOf: newFeeds)
                feedCellConfigs.append(contentsOf: newConfigs)
            } else {
                self.filteredFeeds.append(contentsOf: newFeeds)
                filteredCellConfigs.append(contentsOf: newConfigs)
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
            onNeedReloadFeedList?(feedCellConfigs)
        } else {
            selectedTag = key
            if filteredFeeds.first?.subMenuValue == key {
                // 이전에 저장하고 있는 태그 필터와 동일한 태그를 선택한 경우
                onNeedReloadFeedList?(filteredCellConfigs)
            } else {
                filteredFeeds.removeAll()
                filteredCellConfigs.removeAll()
                getFeedList(completion: onNeedReloadFeedList)
            }
        }
    }
    
    func selectRow(at indexPath: IndexPath) {
        var feed: FeedList.Feed
        if selectedTag == nil {
            feed = feeds[indexPath.row]
        } else {
            feed = filteredFeeds[indexPath.row]
        }
        if feed.category == "NEWS" {
            onShouldMoveNewsDetailView?(feed)
        } else {
            onShouldMoveDetailView?(feed)
        }
    }
}
