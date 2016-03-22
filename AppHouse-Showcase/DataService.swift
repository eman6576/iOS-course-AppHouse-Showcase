//
//  DataService.swift
//  AppHouse-Showcase
//
//  Created by Emanuel  Guerrero on 3/22/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    private var _REF_BASE = Firebase(url: "https://apphouse-showcase.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}