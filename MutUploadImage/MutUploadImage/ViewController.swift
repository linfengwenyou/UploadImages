//
//  ViewController.swift
//  MutUploadImage
//
//  Created by fumi on 2019/2/28.
//  Copyright © 2019 rayor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 测试图片上传
    @IBAction func testGroupUpload(_ sender: Any) {
//        self.testGroupManager()
        self.testMulUploadImage()
    }
    
    func testGroupManager() {
        let groupMana = GroupManager()
        let image = UIImage.init(named: "appoinment_icon")!
        let image2 = UIImage.init(named: "my_custom_service")!
        
        groupMana.uploadImages([image,image2,image,image2,image])
        
    }
    
    
    func testMulUploadImage() {
        let mana = UploadImageManager()
        let image = UIImage.init(named: "appoinment_icon")!
        let image2 = UIImage.init(named: "my_custom_service")!
        
        mana.completeAction = { [weak mana] in
            print("网络传输结束")
            if let manager = mana {
                print(manager.originTags?.map{ $0.serverPath
                    })
                
            }
        }
        mana.uploadImages([image,image2,image,image2,image])
        
    }
}

