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
    static let realm = try! Realm()
    
    @objc dynamic var userName:String!
    @objc dynamic var frequency:Int = 0
    @objc dynamic var lastDate:Date!
    @objc dynamic var imagePhotos: UIImage? {
        set{
            let maxImgSz = 15*1024*1024
            var quarity:CGFloat = 0.9
            var jpegSize = 0
            
            self._imagePhotos = newValue
            if let value = newValue {
                //self.imagePhtData = UIImagePNGRepresentation(value)
                
                //写真はJPEGが良いらしい
                self.imagePhtData = value.jpegData(compressionQuality: quarity)! as NSData
                if let data1 = self.imagePhtData {
                    jpegSize = data1.length
                    
                    while (quarity > 0 && jpegSize > maxImgSz  ) {
                        quarity = quarity - 0.15
                        self.imagePhtData = value.jpegData(compressionQuality: quarity)! as NSData
                        jpegSize = self.imagePhtData!.length
                    }
                }
            }
        }
        get{
            if let image = self._imagePhotos {
                return image
            }
            if let data = self.imagePhtData {
                self._imagePhotos = UIImage(data: data as Data)
                return self._imagePhotos
            }
            return nil
        }
    }
    @objc dynamic private var _imagePhotos: UIImage? = nil
    @objc dynamic private var imagePhtData: NSData? = nil
    @objc dynamic private var id = 0
    
    //保存しないメンバ
    override static func ignoredProperties() -> [String] {
        return ["imagePhotos", "_imagePhotos"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

    static func create() -> Friend {
        let user = Friend()
        user.id = lastId()
        return user
    }

    static func loadAll() -> [Friend] {
        let users = realm.objects(Friend.self).sorted(byKeyPath: "id", ascending: false)
        var ret: [Friend] = []
        for user in users {
            ret.append(user)
        }
        return ret
    }

    static func lastId() -> Int {
        if let user = realm.objects(Friend.self).last {
            return user.id + 1
        } else {
            return 1
        }
    }

    // addのみ
    func save() {
        try! Friend.realm.write {
            Friend.realm.add(self)
        }
    }

    func update(method: (() -> Void)) {
        try! Friend.realm.write {
            method()
        }
    }
    
    func delete(){
        try! Friend.realm.write {
            Friend.realm.delete(self)
        }
    }
    
}
