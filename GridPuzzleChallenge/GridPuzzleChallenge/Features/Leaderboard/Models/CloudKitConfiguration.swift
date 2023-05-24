//
//  CloudKitConfiguration.swift
//  GridPuzzleChallenge
//
//  Created by Muhammad Athif on 22/05/23.
//


import Foundation
import CloudKit

struct CloudKitConfiguration{
    static let container = CKContainer(identifier: "iCloud.com.muhammadathief.GridPuzzleChallenge")
    private init(){}
}
