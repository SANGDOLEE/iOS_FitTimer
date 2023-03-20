//
//  UIViewController+alert.swift
//  FitTimer
//
//  Created by 이상도 on 2023/03/20.
//

import UIKit

// 경고창 구현
extension UIViewController {
    
    func alert(title: String="알림", message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
