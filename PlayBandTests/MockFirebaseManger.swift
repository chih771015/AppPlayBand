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

class MockFirebaseManger: FirebaseReadAndWrite {
    
    var ref: CollectionReference?
    var completionIsAction = false

    func collectionGetDocuments(ref: CollectionReference, completionHandler: @escaping (Result<[FireBaseData]>) -> Void) {
        
        self.ref = ref
        completionIsAction = true
        completionHandler(.success([FireBaseData()]))
    }
    
    func documentUpdata(ref: DocumentReference, data: [AnyHashable : Any], completionHandler: @escaping (Result<Bool>) -> Void) {
        
    }
}
