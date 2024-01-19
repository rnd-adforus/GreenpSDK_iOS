//
//  MypageViewController.swift
//  
//
//  Created by 신아람 on 12/13/23.
//

import UIKit
import SnapKit

class MypageViewController : BaseViewController, UINavigationControllerDelegate {
    private var childs = [MypageListViewController(index: 0), MypageListViewController(index: 1)]
    private var currentIndex: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var myPageControl = MypageControlView(delegate: self)
    private lazy var myPageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(vc)
        return vc
    }()
    
    override func loadView() {
        super.loadView()
        setupLayoutConstraints()
        initView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.childs.first?.feedListViewModel.load()
    }
    
    private func setupLayoutConstraints() {
        
        view.addSubview(myPageControl)
        myPageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50) 
        }
        
        view.addSubview(myPageViewController.view)
        myPageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(myPageControl.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func initView() {
        configureNavigationBar()
        view.backgroundColor = .white
        myPageViewController.setViewControllers([childs.first!], direction: .forward, animated: false, completion: nil)
    }
    
    private func configureNavigationBar() {
        closeButton.tintColor = UserInfo.shared.btnColor
        navigationItem.hidesBackButton = true
        navigationItem.title = "My Page"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: closeButton)
        ]
    }
    
    override func close() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MypageViewController : MypageControlViewDelegate {
    func didTapPageControlAt(index: Int) {
        myPageViewController.setViewControllers([childs[index]], direction: .forward, animated: false, completion: {_ in
            self.childs[index].feedListViewModel.load()
        })
    }
}
