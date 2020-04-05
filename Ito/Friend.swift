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
                       print("bf: imagePhtData.size = \(jpegSize)")
                       
                       while (quarity > 0 && jpegSize > maxImgSz  ) {
                           quarity = quarity - 0.15
                        self.imagePhtData = value.jpegData(compressionQuality: quarity)! as NSData
                           jpegSize = self.imagePhtData!.length
                       }
                   }
                   print("af: imagePhtData.size = \(jpegSize)")
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
    
       //保存しないメンバ
       override static func ignoredProperties() -> [String] {
           return ["imagePhotos", "_imagePhotos"]
       }
}
