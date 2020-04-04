//
//  Friend.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/03.
//  Copyright © 2020 二宮啓. All rights reserved.
//

import Foundation
import RealmSwift

class Friend:Object{
    dynamic var userName:String!
    dynamic var frequency:Int!
    dynamic var lastDate:Date!
    dynamic var userImage:UIImage!
}
