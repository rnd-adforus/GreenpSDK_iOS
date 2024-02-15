//
//  ParticipateViewModel.swift
//
//
//  Created by 신아람 on 12/13/23.
//

import UIKit

class ParticipateViewModel {

    private var typeIdx: Int = 0
    
    private var csInfo: CsListInfo?
    private var participateInfo: ParticipateListInfo?
    private var selectedIndexPath: IndexPath?
    
    var onSuccessLoadParticipateList: (([MypageCellConfig]) -> Void)?
    var onNeedReloadParticipateList: (([MypageCellConfig]) -> Void)?
    var onFailLoadParticipateNoMorePage: (() -> Void)?
    
    private var isLoading: Bool = false
    
    init() {
    }
    
    func setIndex(typeIndex: Int) {
        typeIdx = typeIndex
        
        if(typeIndex == 0) {
            participateInfo = ParticipateListInfo()
        } else {
            csInfo = CsListInfo()
        }
    }
    
    func load() {
        if(typeIdx == 0) {
            getParticipateList(completion: onNeedReloadParticipateList)
        } else {
            getCsList(completion: onNeedReloadParticipateList)
        }
    }
    
    func loadNextPage() {
        if(typeIdx == 0) {
            getParticipateList(completion: onSuccessLoadParticipateList)
        } else {
            getCsList(completion: onSuccessLoadParticipateList)
        }
    }
    
    func getParticipateList(completion: (([MypageCellConfig]) -> Void)?) {
      
        if participateInfo!.lastPageDidLoad {
            onFailLoadParticipateNoMorePage?()
            return
        }
        
        let page = participateInfo!.currentPage
        let param = ParticipateListParam(page: page, limit: FEED_PAGE_LIMIT)
        if isLoading { return }
        Task {
            do {
                isLoading = true
                let result: ParticipateList = try await NetworkManager.shared.request(subURL: "sdk/ads_rwd_list.html", params: param.dictionary, method: .get)
                isLoading = false
                let configs = saveAndConvert(newParticipates: result.data)
                if let completion = completion {
                    completion(configs)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        @Sendable func saveAndConvert(newParticipates: [ParticipateList.Participate]) -> [MypageCellConfig] {
            let newConfigs = newParticipates.map{
                MypageCellConfig(participate: $0)
            }
            
            participateInfo!.list += newParticipates
            participateInfo!.cellConfigs += newConfigs
            participateInfo!.currentPage += 1
            participateInfo!.lastPageDidLoad = newParticipates.count < FEED_PAGE_LIMIT
            
            return newConfigs
        }
    }
    
    func getCsList(completion: (([MypageCellConfig]) -> Void)?) {
      
        if csInfo!.lastPageDidLoad {
            onFailLoadParticipateNoMorePage?()
            return
        }
        
        let page = csInfo!.currentPage
        let param = CsListParam(page: page, limit: FEED_PAGE_LIMIT)
        if isLoading { return }
        Task {
            do {
                isLoading = true
                let result: CsList = try await NetworkManager.shared.request(subURL: "sdk/cs_qna_list_new.html", params: param.dictionary, method: .get)
                isLoading = false
                let configs = saveAndConvert(newParticipates: result.data)
                if let completion = completion {
                    completion(configs)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        @Sendable func saveAndConvert(newParticipates: [CsList.Cs]) -> [MypageCellConfig] {
            let newConfigs = newParticipates.map{
                MypageCellConfig(cs: $0)
            }
            
            csInfo!.list += newParticipates
            csInfo!.cellConfigs += newConfigs
            csInfo!.currentPage += 1
            csInfo!.lastPageDidLoad = newParticipates.count < FEED_PAGE_LIMIT
            
            return newConfigs
        }
    }
    
    func selectRow(at indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func deleteRow() {
        guard let selectedIndexPath = selectedIndexPath else { return }
    }
}
