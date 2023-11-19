//
//  GreenPBuilder.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation
import UIKit

open class GreenPBuilder {
    internal init() {}

    public func initilize(on viewController: UIViewController) {
        let vc = SplashViewController()
//        let vc = OfferWallViewController()
        let navi = NavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .automatic
        navi.isModalInPresentation = true
        viewController.present(navi, animated: true, completion: nil)
    }
}
