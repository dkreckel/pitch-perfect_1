//
//  RecordedAudio.swift
//  Pitch Perfect 2
//
//  Created by Darrell Kreckel on 5/23/15.
//  Copyright (c) 2015 Darrell Kreckel. All rights reserved.
//

import Foundation


class RecordedAudio {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl:NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
