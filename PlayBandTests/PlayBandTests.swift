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
    // swiftlint:disable all
    let mockFirebase = MockFirebaseManger()
    lazy var firebaseStorManger = FireBaseStoreDataManger(firebaseManger: mockFirebase)
    
    override func setUp() {
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_getStoreData_correct() {
        
        var dictionary: [[String: Any]] = [[StoreDataKey.name.rawValue: "TestStore",
                                          StoreDataKey.opentime.rawValue: "09",
                                          StoreDataKey.address.rawValue: "TestAddress",
                                          StoreDataKey.city.rawValue: "TestCity",
                                          StoreDataKey.closetime.rawValue: "22",
                                          StoreDataKey.information.rawValue: "AAAAAAA",
                                          StoreDataKey.images.rawValue: ["sssss"],
                                          StoreDataKey.phone.rawValue: "0987654321",
                                          StoreDataKey.photourl.rawValue: "WWWWWWWWW",
                                          StoreDataKey.rooms.rawValue: [
                                            [StoreDataKey.name.rawValue: "roomA", StoreDataKey.price.rawValue: "400"]
                                            ]
                                            ]]
        mockFirebase.getStoreDataResult = .success(dictionary)
        var resultError: Error?
        var resultData: [StoreData] = []
        let expectedPath = FirebaseCollectionName.store.name
        firebaseStorManger.getStoresData { (result) in
            
            switch result {
                
            case .failure(let error):
                
                resultError = error
            case .success(let data):
                
                resultData = data
            }
        }
        XCTAssert(resultError == nil)
        XCTAssertEqual(resultData.count, dictionary.count)
        XCTAssertEqual(resultData[0].address, dictionary[0][StoreDataKey.address.rawValue] as! String)
        XCTAssertEqual(mockFirebase.collectionRef?.path, expectedPath)
        XCTAssert(mockFirebase.completionIsAction)
    
    }
    
    func test_getStoreData_fail() {
        
        mockFirebase.getStoreDataResult = .failure(FirebaseDataError.document)
        var resultError: Error?
        let expectedResultError = FirebaseDataError.document
        var resultData: [StoreData] = []
        let expectedPath = FirebaseCollectionName.store.name
        firebaseStorManger.getStoresData { (result) in
            
            switch result {
                
            case .failure(let error):
                resultError = error
            case .success(let data):
                
                resultData = data
            }
        }
        
        if let actualResultError = resultError as? FirebaseDataError {
            
            XCTAssertEqual(actualResultError, expectedResultError)
            
        } else {
            
            XCTFail()
        }
        
        XCTAssertTrue(resultData.isEmpty)
        XCTAssertEqual(mockFirebase.collectionRef?.path, expectedPath)
        XCTAssert(mockFirebase.completionIsAction)
    }
    
    func test_getStoreData_decodeFail() {
        
        mockFirebase.getStoreDataResult = .success([["sss": 123]])
        var resultError: Error?
        let expectedResultError = FirebaseDataError.decodeFail
        var resultData: [StoreData] = []
        let expectedPath = FirebaseCollectionName.store.name
        firebaseStorManger.getStoresData { (result) in
            
            switch result {
                
            case .failure(let error):
                resultError = error
            case .success(let data):
                
                resultData = data
            }
        }
        
        
        XCTAssertTrue(resultError is FirebaseDataError)
        
        XCTAssertEqual(resultError as! FirebaseDataError, expectedResultError)
//        if let actualResultError = resultError as? FirebaseDataError {
//            
//            XCTAssertEqual(actualResultError, expectedResultError)
//
//        } else {
//            
//            XCTFail("Error 型別不對")
//        }
        
        XCTAssertTrue(resultData.isEmpty)
        XCTAssertEqual(mockFirebase.collectionRef?.path, expectedPath)
        XCTAssert(mockFirebase.completionIsAction)
    }
    
    func test_upDataStoreData_success() {
        
        var storeData = StoreData()
        storeData.name = "Test"
        mockFirebase.documentUpdataResult = .success(true)
        let expectedPath = FirebaseCollectionName.store.name + "/" + storeData.name
        firebaseStorManger.updateStoreData(storeData: storeData) { (result) in
            
            switch result {
                
            case .success:
                
                XCTAssert(true)
            case .failure:
                
                XCTFail()
            }
        }
        
        XCTAssertEqual(mockFirebase.documentRef?.path, expectedPath)
        XCTAssert(mockFirebase.completionIsAction)
    }
    
    func test_upDataStoreData_fail() {
        
        var storeData = StoreData()
        storeData.name = "Test"
        let expectedPath = FirebaseCollectionName.store.name + "/" + storeData.name
        mockFirebase.documentUpdataResult = .failure(InputError.information)
        firebaseStorManger.updateStoreData(storeData: storeData) { (result) in
            
            switch result {
                
            case .success:
                
                XCTFail()
            case .failure(let error):
                
                guard let decodeError = error as? InputError else {
                    
                    XCTFail()
                    return
                }
                
                switch decodeError {
                    
                case .information:
                    
                    XCTAssert(true)
                default:
                    
                    XCTFail()
                }
            }
        }
        
        XCTAssertEqual(mockFirebase.documentRef?.path, expectedPath)
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
