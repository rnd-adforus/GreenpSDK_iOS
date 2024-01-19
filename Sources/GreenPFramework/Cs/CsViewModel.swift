//
//  CsViewModel.swift
//  
//
//  Created by 신아람 on 1/3/24.
//

import UIKit

class CsViewModel {
    
    private var participateListForCs: [ParticipateListForCs.ParticipateForCs] = []
    
    var onSuccessLoadCampaignList: (([ParticipateListForCs.ParticipateForCs]) -> Void)?
    var onSuccessSendCs: ((String) -> Void)?
    
    private var isLoading: Bool = false
    
    init() {
    }
    
    func load() {
        getParticipateListForCs(completion: onSuccessLoadCampaignList)
    }
    
    func sendCs(param: SendCsParam) {
        sendCs(param: param, completion: onSuccessSendCs)
    }
    
    private func getParticipateListForCs(completion: (([ParticipateListForCs.ParticipateForCs]) -> Void)?) {
        let param = ParticipateListForCsParam()
        if isLoading { return }
        Task {
            do {
                isLoading = true
                let result: ParticipateListForCs = try await NetworkManager.shared.request(subURL: "sdk/ads_rwd_join_list.html", params: param.dictionary, method: .get)
                isLoading = false
                if let completion = completion {
                    completion(result.data)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func sendCs(param: SendCsParam, completion: ((String) -> Void)?) {
        if isLoading { return }
        Task {
            do {
                isLoading = true
                
                var result: APIResult
                if let file = param.file {
                    
                    print("has file")
                    
                    result = try await NetworkManager.shared.requestWithFile(subURL: "sdk/cs_qna_regist.html", fileURL: file, params: param.dictionary!, method: .post)
                } else {
                    
                    print("no file")
                    
                    result = try await NetworkManager.shared.request(subURL: "sdk/cs_qna_regist.html", params: param.dictionary, method: .get)
                }
                isLoading = false
                if let completion = completion {
                    if(result.result == "0" || result.result == "S") {
                        result.message = ""
                    }
                    completion(result.message)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
