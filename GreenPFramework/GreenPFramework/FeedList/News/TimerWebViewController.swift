//
//  TimerWebViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/19.
//

import UIKit

protocol TimerWebViewControllerDelegate : AnyObject {
    func timerWebViewDidCompleteAddJoin()
}

class TimerWebViewController : WebViewController {
    public var timerWebViewModel: TimerWebViewModel!
    public weak var delegate: TimerWebViewControllerDelegate?
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        let label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .nanumSquare(size: 30, family: .extraBold)
            let attrString = NSAttributedString(
                string: "뉴스기사를 스크롤하시면 시청시간 카운트가 시작됩니다.",
                attributes: [
                    NSAttributedString.Key.strokeColor: UIColor.blue,
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.strokeWidth: -1.0,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30.0)
                ]
            )
            label.attributedText = attrString
            return label
        }()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        return view
    }()
    private let progressView = CircleProgressView()
    
    // MARK: View lifecycle

    override func loadView() {
        super.loadView()
        setupLayoutConstraints()
        initView()
        setupActions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerWebViewModel.onProgressTimer = { time, passedTime in
            self.refreshProgressView(time: time, passedTime: passedTime)
        }
        timerWebViewModel.onEndTimer = {
            self.requestParticipateInNews()
        }
        timerWebViewModel.onSuccessParticipate = {
            self.presentSuccessParticipate()
        }
        timerWebViewModel.onFailureParticipate = { message in
            DispatchQueue.main.async {
                self.alert(message: message, cancelTitle: "확인")
            }
        }
        timerWebViewModel.onComfirmDismiss = {
            self.dismiss(animated: true)
        }
        timerWebViewModel.onShowAlertOnDismiss = {
            self.presentConfirmDismissAlert()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(closeButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerWebViewModel.pauseTimer()
    }
    
    /// Initialize constraints
    private func setupLayoutConstraints() {
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(70)
            make.right.bottom.equalToSuperview().inset(20)
        }
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// Initialize properties
    private func initView() {
        progressView.isHidden = true
    }
    
    /// Initialize actions
    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(gestureDidBegin(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(gestureDidBegin(_:)))
        tap.delegate = self
        pan.delegate = self
        infoView.addGestureRecognizer(tap)
        infoView.addGestureRecognizer(pan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func gestureDidBegin(_ gesture: UIGestureRecognizer) {
        infoView.isHidden = true
        progressView.isHidden = false
        timerWebViewModel.startTimer()
    }
    
    @objc private func didEnterBackground() {
        timerWebViewModel.pauseTimer()
    }
    
    @objc private func willEnterForeground() {
        timerWebViewModel.resumeTimer()
    }
    
    override func close() {
        timerWebViewModel.checkCanDismiss()
    }
    
    private func refreshProgressView(time: Int, passedTime: Int) {
        progressView.set(time: time, passedTime: passedTime)
    }
    
    private func requestParticipateInNews() {
        timerWebViewModel.participateInNews()
    }
    
    private func presentSuccessParticipate() {
        DispatchQueue.main.async {
            self.progressView.stop()
            self.delegate?.timerWebViewDidCompleteAddJoin()
        }
    }
    
    private func presentConfirmDismissAlert() {
        alert(message: "지금 페이지를 나가시면 리워드를 적립받을 수 없습니다.\n페이지를 나가시겠습니까?", title: "알림", confirmTitle: "나가기", confirmHandler: { _ in
            self.dismiss(animated: true)
        }, cancelTitle: "머무르기") { _ in
            self.timerWebViewModel.resumeTimer()
        }
    }
}

extension TimerWebViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension TimerWebViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        timerWebViewModel.checkCanDismiss()
    }
}
