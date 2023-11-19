//
//  TimerWebViewModel.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/19.
//

import Foundation

class TimerWebViewModel {
    public var info: ParticipateInfo
    
    private var timer: Timer?
    private var totalTimeMilli: Int = 0
    private var leftTime: Int = 0
    var onProgressTimer: ((Int, Int) -> Void)?
    var onEndTimer: (() -> Void)?
    var onSuccessParticipate: (() -> Void)?
    var onFailureParticipate: ((String) -> Void)?

    init(info: ParticipateInfo) {
        self.info = info
        self.totalTimeMilli = info.time ?? 5000
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(start), userInfo: nil, repeats: true)
        leftTime = totalTimeMilli
        onProgressTimer?(totalTimeMilli, 0)
    }
    
    @objc func start() {
        leftTime -= 1
        onProgressTimer?(Int(totalTimeMilli), Int(totalTimeMilli - leftTime))
        
        if leftTime <= 0 {
            timer?.invalidate()
            timer = nil
            onEndTimer?()
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    func resumeTimer() {
        if leftTime <= 0 {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(start), userInfo: nil, repeats: true)
    }
    
    func participateInNews() {
        guard let key = info.greenPKey else {
            onFailureParticipate?("고유 키 값이 잘못되었습니다.")
            return
        }
        let param = ParticipateNewsParam(key: key)

        Task {
            do {
                let result: APIResult = try await NetworkManager.shared.request(subURL: "postback/newpic.proc", params: param.dictionary, method: .get)
                if result.result == "S" {
                    onSuccessParticipate?()
                } else {
                    onFailureParticipate?(result.message)
                }
            } catch let error {
                onFailureParticipate?(error.localizedDescription)
            }
        }
    }
}
