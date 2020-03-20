//
//  AppVersion.swift
//  BKI
//
//  Created by sreenivasula reddy on 20/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import Foundation

//About App Build and version Number
struct AboutItem
{
    let version: String?
    let build: String?
    init() {
        version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}
