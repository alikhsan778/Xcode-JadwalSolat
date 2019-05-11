//
//  MusimSolatResponses.swift
//  Jadwal Solat
//
//  Created by Muhammad Utsman on 5/11/19.
//  Copyright © 2019 Muhammad Utsman. All rights reserved.
//

import UIKit

struct MuslimSolatResponses: Decodable {
    let solat: [Salat]
    
    enum CodingKeys: String, CodingKey {
        case solat = "items"
    }
    
}

struct Salat: Decodable {
    let subuh: String
    let dzuhur: String
    let ashar: String
    let magrib: String
    let isya: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date_for"
        case subuh = "fajr"
        case dzuhur = "dhuhr"
        case ashar = "asr"
        case magrib = "maghrib"
        case isya = "isha"
    }
}
