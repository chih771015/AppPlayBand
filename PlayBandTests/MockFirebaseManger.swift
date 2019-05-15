//
//  MockFirebaseManger.swift
//  PlayBandTests
//
//  Created by 姜旦旦 on 2019/5/13.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import Firebase
@testable import PlayBand

class MockFirebaseManger {
    
    var collectionRef: CollectionReference?
    var completionIsAction = false
    var getStoreDataResult: Result<[FireBaseData]>!
    var documentRef: DocumentReference?
    var documentUpdataResult: Result<Bool>!
    var path: String = ""
}

extension MockFirebaseManger: FirebaseReadAndWrite {
    
    func collectionGetDocuments(
        ref: CollectionReference,
        completionHandler: @escaping (Result<[FireBaseData]>) -> Void) {
        
        self.collectionRef = ref
        completionIsAction = true
        completionHandler(getStoreDataResult)
    }
    
    func documentUpdata(
        ref: DocumentReference,
        data: [AnyHashable: Any],
        completionHandler: @escaping (Result<Bool>) -> Void) {
        
        self.documentRef = ref
        completionIsAction = true
        completionHandler(documentUpdataResult)
    }
}
