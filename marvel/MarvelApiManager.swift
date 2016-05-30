//
//  MarvelApiManager.swift
//  marvel
//
//  Created by khlebtsov alexey on 30/05/16.
//
//

import UIKit

struct MarvelApiManager{
    static let request = MarvelRequest(baseUrl: Config.baseUrl, privateKey: Config.Keys.marvelPrivate, publicKey: Config.Keys.marvelPublic)
}
