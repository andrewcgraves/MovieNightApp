//
//  PendingOperations.swift
//  MovieNightApp
//
//  Created by Andrew Graves on 12/16/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import Foundation

class PendingOperations {
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()
}