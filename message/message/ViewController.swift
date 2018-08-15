//
//  ViewController.swift
//  message
//
//  Created by RD-Air01 on 2018/8/11.
//  Copyright © 2018年 RD-Air01. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //確保在主線程中執行
        DispatchQueue.main.async {
            //判斷推播權限設定的狀態，如果是不允許則跳出提醒，按確定後前往設定權限畫面
            if !MessageManager.sharedInstance().isMessageEnable {
                self.showAlert(message: "為了避免遺漏重要訊息\n請點選確定以打開通知功能", completion:
                    {
                        MessageManager.sharedInstance().openAppSetting()
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //提醒視窗
    func showAlert(message: String!, completion:@escaping () -> Void) {
        UIAlertController.alert(message: message).otherHandle(alertAction: { (action) in
            completion()
        }).cancelHandle(alertAction: nil ).show(currentVC: self)
    }
}

