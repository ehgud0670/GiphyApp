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
    static func presentAlertWithNetworkError(to viewController: UIViewController) {
        let alertController = UIAlertController(
            title: "네트워크 상태를 확인해주세요",
            message: "서버와 통신이 원활하지 않아 데이터를 불러올 수 없습니다.",
            preferredStyle: .alert
        ).then {
            $0.addAction(UIAlertAction(title: "OK", style: .default))
        }
        viewController.present(alertController, animated: true)
    }
}
