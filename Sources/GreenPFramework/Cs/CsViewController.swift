//
//  CsViewController.swift
//  
//
//  Created by 신아람 on 1/2/24.
//

import UIKit
import SnapKit

class CsViewController : BaseViewController, UINavigationControllerDelegate {
    
    public let csViewModel = CsViewModel()
    let inputItemsView = CsItemView()
    
    var selectedCampaign = 0
    
    let csTypeList: [String] = ["광고적립 문의", "기타 문의"]
    var campaignList: [ParticipateListForCs.ParticipateForCs] = []
    var originCampaignList: [ParticipateListForCs.ParticipateForCs] = []
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        setupLayoutConstraints()
        initView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csViewModel.onSuccessSendCs = { msg in
            
            var txt = msg
            if(msg.isEmpty) {
                txt = "문의사항이 등록되었습니다.\n확인 후 빠른 시간내에 답변 드리겠습니다"
            }
            
            self.alert(message: txt, cancelTitle: "확인", cancelHandler: { action in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        
        csViewModel.onSuccessLoadCampaignList = { list in
            self.inputItemsView.configure(list: list)
        }
        
        csViewModel.load()
        
        inputItemsView.onClickSendCs = { msg, param in
            
            if let unwrappedParam = param {
                print(unwrappedParam.content)
                self.csViewModel.sendCs(param: unwrappedParam)
            } else {
                self.alert(message: msg, cancelTitle: "확인")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupLayoutConstraints() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(inputItemsView)
        inputItemsView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    private func initView() {
        configureNavigationBar()
        view.backgroundColor = .white
    }
    
    private func configureNavigationBar() {
        closeButton.tintColor = UserInfo.shared.btnColor
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "문의하기"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: closeButton)
        ]
    }
    
    override func close() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        // contentInset을 키보드의 높이만큼 조절
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        // contentInset을 원래대로 돌려놓음
        scrollView.contentInset = UIEdgeInsets.zero
    }
}
