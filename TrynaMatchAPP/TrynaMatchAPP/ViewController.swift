//
//  ViewController.swift
//  TrynaMatchAPP
//
//  Created by KV Ghumaan on 5/25/17.
//  Copyright © 2017 KV Ghumaan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
    }


}

