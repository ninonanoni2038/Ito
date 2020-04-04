//
//  AddFriendViewController.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/03.
//  Copyright © 2020 二宮啓. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet var userImage:UIImageView!
    @IBOutlet var userNameTextField:UITextField!
    @IBOutlet var frequencyTextField:UITextField!
   // @IBOutlet var frequencyTextField:PickerTextField = PickerTextField()
    @IBOutlet var lastDayTextField:UITextField!
    
    var frequecyPickerView:UIPickerView = ()
    let frequencyDataList = ["1週間に一度","2週間に一度","3週間に一度","1ヶ月に一度","2ヶ月に一度"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        frequencyPickerView.delegate = self
        frequencyPickerView.dataSource = self

    }
    
    @IBAction func save(){
        
    }
    

}
