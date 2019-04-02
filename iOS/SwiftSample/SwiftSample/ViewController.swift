//
//  ViewController.swift
//  SwiftSample
//
//  Created by wenyongjun on 2019/4/1.
//  Copyright © 2019年 wenyongjun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        UIButton
        let newButton:UIButton = UIButton(frame: CGRect(x: 20, y: 60, width: 150, height: 50));
        newButton.backgroundColor = UIColor.blue;
        newButton.setTitle("点我", for: .normal);
        newButton.addTarget(self, action: #selector(newButtonAction), for: .touchUpInside);
        self.view.addSubview(newButton);
        
//        UILabel
        let newLabel:UILabel = UILabel(frame: CGRect(x: 20, y: 160, width: 150, height: 50));
        newLabel.backgroundColor = UIColor.red;
        newLabel.text = "23423424";
        self.view.addSubview(newLabel);
    }
    
    @objc func newButtonAction() {
        print("select new button")
    }


}

