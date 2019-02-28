//
//  MutUploadImageTests.swift
//  MutUploadImageTests
//
//  Created by fumi on 2019/2/28.
//  Copyright © 2019 rayor. All rights reserved.
//

import XCTest
@testable import MutUploadImage

class MutUploadImageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGroupManager() {
        let groupMana = GroupManager()
        let image = UIImage.init(named: "appoinment_icon")!
        let image2 = UIImage.init(named: "my_custom_service")!
        
        groupMana.uploadImages([image,image2,image,image2,image])
        
        let exception = self.expectation(description: "测试异常信息")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20) {
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 22) { (error) in
            XCTAssert(true)
        }
        
        XCTAssert(true)
    }

    
    func testMulUploadImage() {
        let mana = UploadImageManager()
        let image = UIImage.init(named: "appoinment_icon")!
        let image2 = UIImage.init(named: "my_custom_service")!
        
        mana.completeAction = {
            print("网络传输结束")
            print(mana.originTags?.map({ $0.serverPath
            }))
        }
        mana.uploadImages([image,image2,image,image2,image])
        
        let exception = self.expectation(description: "测试异常信息")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20) {
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 22) { (error) in
            XCTAssert(true)
        }
        
        XCTAssert(true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
