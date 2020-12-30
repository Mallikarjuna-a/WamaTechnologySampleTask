//
//  DataStructureFromServer.swift
//  WamaTechnologySampleTask
//
//  Created by Mallikarjuna on 30/12/20.
//  Copyright © 2020 Mallikarjuna. All rights reserved.
//

import Foundation

struct DataStruct: Codable {
    var results:[ResultsStruct]?
}
struct ResultsStruct: Codable {
    var id:Int?
    var original_language:String?
    var title:String?
    var overview:String?
    var poster_path:String?
    var release_date:String?
    var vote_average:Float?
    var vote_count:Int?
}
