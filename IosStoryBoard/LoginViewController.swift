//
//  ViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 3/20/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var EnterID: UITextField!
    @IBOutlet weak var EnterPassword: UITextField!

    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var SignUPBtn: UIButton!

    @IBOutlet weak var AppTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


    func setupUI() {
        // 앱 타이틀 폰트 적용
        AppTitle.font = UIFont.pretendardBold(size: 28)
        AppTitle.text = "dAIry"
        AppTitle.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0) // #2C3E50
        AppTitle.textAlignment = .center
    }
}
