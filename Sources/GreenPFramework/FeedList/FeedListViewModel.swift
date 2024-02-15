//
//  FeedListViewModel.swift
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
    private var feedList: [FeedInfo] = []
    private var selectedIndexPath: IndexPath?
    
    var onSuccessLoadCategories: (([SettingsData.Data.Tab.Filter]) -> Void)?
    var onSuccessLoadFeedList: (([FeedCellConfig]) -> Void)?
    var onNeedReloadFeedList: (([FeedCellConfig]) -> Void)?
    var onFailLoadFeedNoMorePage: (() -> Void)?
    var onShouldMoveDetailView: ((FeedList.Feed) -> Void)?
    var onShouldMoveNewsDetailView: ((FeedList.Feed) -> Void)?
    var onShouldDeleteCellConfig: ((IndexPath) -> Void)?
    
    private var isLoading: Bool = false
    
    private var isMainListLoading: Bool = false
    private var mainList: [MainData.Main] = []
    var onSuccessLoadMainList: (([MainData.Main]) -> Void)?
    
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
        let page = list.currentPage
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
            let newConfigs = newFeeds.map{
                FeedCellConfig(feed: $0, buttonTitle: UserInfo.shared.tabs[tabIndex].name)
            }
            for (i, list) in feedList.enumerated() {
                if list.key == tag {
                    feedList[i].feeds += newFeeds
                    feedList[i].cellConfigs += newConfigs
                    feedList[i].currentPage += 1
                    feedList[i].lastPageDidLoad = newFeeds.count < FEED_PAGE_LIMIT
                }
            }
            return newConfigs
        }
    }
    
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
        self.selectedIndexPath = indexPath
        let feed = feedList[indexPath.row]
        if feed.category == "NEWS" {
            onShouldMoveNewsDetailView?(feed)
        } else {
            onShouldMoveDetailView?(feed)
        }
    }
    
    func selectRow(at indexPath: IndexPath, idx: Int) {
        guard let feedList = feedList.filter({ $0.key == selectedTag ?? TAG_KEY_ALL }).first?.feeds else {
            return
        }
        self.selectedIndexPath = indexPath
        let feed = feedList[idx]
        if feed.category == "NEWS" {
            onShouldMoveNewsDetailView?(feed)
        } else {
            onShouldMoveDetailView?(feed)
        }
    }
    
    func deleteRow() {
        guard let selectedIndexPath = selectedIndexPath else { return }
        let tagKey = selectedTag ?? TAG_KEY_ALL
        let tagIndex = tags.enumerated().filter({ $0.1.key == tagKey }).first?.offset ?? 0
        let index = tabIndex == 2 ? 0 : tagIndex
        if feedList[index].feeds.count < selectedIndexPath.row { return }
        feedList[index].feeds.remove(at: selectedIndexPath.row)
        onShouldDeleteCellConfig?(selectedIndexPath)
    }
    
    func getMainList(completion: (([MainData.Main]) -> Void)?) {
        
        print("getFeedList")
        
        let param = MainListParam()
        if isMainListLoading { return }
        Task {
            do {
                isMainListLoading = true
                let result: MainData = try await NetworkManager.shared.request(subURL: "sdk/main_list.html", params: param.dictionary, method: .get)
                isMainListLoading = false

                mainList = makeMainList(main: result.data.topData, reward: result.data.rewardData)
                if let completion = completion {
                    completion(mainList)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        @Sendable func makeMainList(main: [MainData.Main], reward: MainData.UAdReward) -> [MainData.Main] {
            var mainList: [MainData.Main] = []
            
            if(!reward.iconURLStr.isEmpty) {
                let reward = MainData.Main(id: "reward", name: "reward", cate: "", iconURLStr: reward.iconURLStr, price: 0, pointType: "", briefText: "", summary: "")
                mainList.append(reward)
            }
            
            let randomIndex = Int.random(in: 0..<main.count)
            mainList.append(main[randomIndex])
            
            return mainList
        }
    }
    
    func mainDataConverter(data: MainData.Main) -> FeedList.Feed {
        let feed = FeedList.Feed(id: data.id, name: data.name, subTitle: data.briefText, price: data.price, summary: data.summary, imageURLStr: data.iconURLStr, iconURLStr: data.iconURLStr, subMenuValue: "", reward: data.price, category: data.cate, pointType: data.pointType)
        
        return feed
    }
}
