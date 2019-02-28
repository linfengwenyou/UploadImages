
//
//  UploadImageManager.swift
//  ThreadTestDemo
//
//  Created by fumi on 2019/2/23.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation
import UIKit

/** 图片上传对象进行封装 */
class UploadImageInfo {
    var task:Operation!             // 任务执行
    var serverPath:String?          // 服务器存储地址
    var image:UIImage?              // 保存的图片信息
}

class UploadImageManager: NSObject {

    /** 原始图片数据 */
    var originImages:[UIImage]?
    
    /** 初始标记与原始图片顺序一致 */
    var originTags:[UploadImageInfo]?
    
    /** 完成上传后的事件 */
    var completeAction:(()->())?
    
    /** 创建一个队列用来管理操作队列 */
    lazy var queue:OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 4
        q.name = "com.song.uploadImages"
        return q
    }()
    
    /** 返回图片上传后的地址信息， 最好通过闭包进行返回 ([String]?) -> Void  方便后续处理*/
    func uploadImages(_ images:[UIImage]) {
        
        self.originImages = images
        
        self.originTags = images.map({ (image) -> UploadImageInfo in
            let operation = taskWithImages(image)
            let imageInfo = UploadImageInfo.init()
            imageInfo.task = operation
            imageInfo.image = image
            return imageInfo
        })
        
        // 开始执行下载操作
      let _ =  self.originTags?.map { (imageInfo) in
            self.queue.addOperation(imageInfo.task)
        }
        
    }
    
    func taskWithImages(_ image:UIImage) -> Operation {
        
        let myOperation = MyOperation()
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
            let imageInfo = self.originTags?.filter({ (info) -> Bool in
                info.task.isEqual(myOperation)
            }).first
            
            imageInfo?.serverPath = "\(Thread.current.description)"
            
            
            print("上传好一张图片：\(imageInfo?.serverPath)")
            
            // 执行事件进行处理
            if error != nil {
                print(error!.localizedDescription)
            }
            if self.queue.operationCount == 0 {
                
                if let complete = self.completeAction {
                    complete()
                }
            }
        }
        
        myOperation.task = uploadTask
        
        // 如果任务执行完毕，但是还没有得到
        return myOperation
    }
    
    deinit {
         print("销毁成功")
    }
}

