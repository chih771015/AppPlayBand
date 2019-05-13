//
//  PlayBandTests.swift
//  PlayBandTests
//
//  Created by 姜旦旦 on 2019/5/10.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import XCTest
import UIKit
import Firebase
@testable import PlayBand

class PlayBandTests: XCTestCase {
    
    let mockFirebase = MockFirebaseManger()
    lazy var firebaseStorManger = FireBaseStoreDataManger(firebaseManger: mockFirebase)
    
    override func setUp() {
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_getStoreData_correct() {
        
        firebaseStorManger.getStoresData { (result) in

        }
        XCTAssert(mockFirebase.ref?.collectionID == FirebaseCollectionName.store.name)
        XCTAssert(mockFirebase.completionIsAction)
    }
    
    func test_getStoreData_fail() {
        
        firebaseStorManger.getStoresData(refName: .booking) { (result) in
            
        }
        XCTAssert(mockFirebase.ref?.collectionID != FirebaseCollectionName.store.name)
        XCTAssert(mockFirebase.completionIsAction)
    }
    
    func testPlayBand() {
        
        //3A - Arrange, Action, Assert
        
        // Arrange
        
//        let aaa = 10
//
//        let bbb = 20
//
//        let expectedResult = aaa + bbb
//
//        // Action
//
//        let actualResult = add(aaa: aaa, bbb: bbb)
//
//        // Assert
//
//        XCTAssertEqual(actualResult, expectedResult)
//
//        print("AAAA")
    }
    
}
