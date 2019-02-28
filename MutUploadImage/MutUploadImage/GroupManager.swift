
//
//  GroupManager.swift
//  MutUploadImage
//
//  Created by fumi on 2019/2/28.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation
import UIKit

class GroupManager {
    
    let group = DispatchGroup()
  
    func uploadImages(_ images:[UIImage]) {
    
        let queue = DispatchQueue.init(label: "com.song.test")
        print("start....", Thread.current)
        
        for image in images {
            queue.async(group: group, qos: .default, flags: .detached) {
                self.uploadImage(image)
            }
        }
        
    }
    
    /** 标记是否完成 */
    var completeFlag = 0
    
    func uploadImage(_ image:UIImage) {
        
        self.group.enter()
        
        // 图片上传
        let session = URLSession.shared
        
        let request = NSMutableURLRequest.init(url: URL.init(string: "https://www.baidu.com")!)
        request.addValue("application/json", forHTTPHeaderField: "Content_Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.timeoutInterval = 40
        
        var data = image.pngData()
        if data == nil {
            data = image.jpegData(compressionQuality: 0.8)
        }
        
        let uploadTask = session.uploadTask(with: request as URLRequest, from: data) { (data, response, error) in
            // 判断image
            // 执行事件进行处理
            if error != nil {
                print(error!.localizedDescription)
            }
           
            print("图片上传结束了, \(Thread.current.description)")
            
            if self.completeFlag == 0 {         // 拦截所有图片上传成功
                self.group.notify(queue: DispatchQueue.main, execute: {
                    print("所有图片上传结束")
                })
                self.completeFlag = 1
            }
            
            // 此处进行组退出？
             self.group.leave()
            
        }
        uploadTask.resume()
        
    }
    
    deinit {
        print("销毁成功")
    }
}
