//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jay Lynch on 17/02/2015.
//  Copyright (c) 2015 Jay Lynch. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String

    override init() {
        self.filePathUrl = NSURL()
        self.title = String()
        
        super.init()
    }
    
    init(path: NSURL, title: String) {
        self.filePathUrl = path
        self.title = title
        
        super.init()
    }
}