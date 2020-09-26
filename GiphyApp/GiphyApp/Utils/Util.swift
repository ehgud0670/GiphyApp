//
//  AlertControllerExtensions.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then

struct Util {
    static func presentAlert(title: String, message: String?, to viewController: UIViewController) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        ).then {
            $0.addAction(UIAlertAction(title: "OK", style: .default))
        }
        
        viewController.present(alertController, animated: true)
    }
    
    static func presentAlertWithNetworkError(to viewController: UIViewController) {
        presentAlert(
            title: "네트워크 상태를 확인해주세요",
            message: "서버와 통신이 원활하지 않아 데이터를 불러올 수 없습니다.",
            to: viewController
        )
    }
    
    static func presetAlertWithCanNotFavorite(to viewController: UIViewController) {
        presentAlert(
            title: "적용할 수 없습니다.",
            message: "디스크가 가득차 적용할 수 없습니다.",
            to: viewController
        )
    }
}
