//
//  FetchPhotoOperations.swift
//  Astronomy
//
//  Created by Bobby Keffury on 11/13/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    init(photoReference: MarsPhotoReference, session: URLSession = URLSession.shared) {
        self.photoReference = photoReference
        self.session = session
        super.init()
    }
 
    override func start() {
        state = .isExecuting
        let url = photoReference.imageURL.usingHTTPS!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.photoReference): \(error)")
                return
            }
            
            self.imageData = data
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: Properties
    
    let photoReference: MarsPhotoReference
    
    private let session: URLSession

    private(set) var imageData: Data?
    
    private var dataTask: URLSessionDataTask?
}
