//
//  MyOperation.swift
//  ThreadTestDemo
//
//  Created by fumi on 2019/2/25.
//  Copyright © 2019 rayor. All rights reserved.
//

import UIKit
import Foundation

class MyOperation: Operation {

    /** 是否异步 */
    fileprivate var _isAsynchronous: Bool = false
    override var isAsynchronous: Bool {
        get { return _isAsynchronous }
        set {
            willChangeValue(forKey: "isAsynchronous")
            _isAsynchronous = newValue
            didChangeValue(forKey: "isAsynchronous")
        }
    }
    
    /** 是否开始执行 */
    fileprivate var _isExecuting: Bool = false
    override var isExecuting: Bool {
        get { return _isExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    /** 是否执行 */
    fileprivate var _isFinshed:Bool = false
    override var isFinished: Bool {
        get { return _isFinshed }
        set {
            willChangeValue(forKey: "isFinished")
            _isFinshed = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    // 根据配置的图片进行数据获取，成功后返回指定的图片URL
    
    var task: URLSessionUploadTask?
    
    var image:UIImage?
    var url:String?
    
    
    // 自定义操作
    override func start() {
        if !isCancelled {
            isExecuting = true
            isFinished = false
            isAsynchronous = true
            
            
            // 添加监听网络状态
            self.task?.addObserver(self, forKeyPath: "state", options: [.new,.old], context: nil)
            
            Thread.detachNewThreadSelector(#selector(self.asyncShowValues), toTarget: self, with: nil)
            // 创建一个数据信息
        } else {
            isFinished = true
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let state = self.task?.state ,( state == .canceling || state == .completed) {
            print("状态发生改变")
            isFinished = true
            isExecuting = false
        }
    }
    
    /** 异步开始执行 */
    @objc func asyncShowValues() {
        self.task?.resume()
    }
    
}
