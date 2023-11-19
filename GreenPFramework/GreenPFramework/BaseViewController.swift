//
//  BaseViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/19.
//

import UIKit

class BaseViewController : UIViewController {
    // MARK: Setup UI properties
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    public func configureCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}

open class NavigationController : UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // dark 모드 사용 안함
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }

    deinit {
        print("\(DEBUG_MARK)deinit.")
    }
    
}
