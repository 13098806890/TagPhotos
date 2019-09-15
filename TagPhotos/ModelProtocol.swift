//
//  ModelProtocol.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/14.
//  Copyright © 2019 Teemo. All rights reserved.
//

import Foundation

protocol ModelProtocol {
    func numbersOfSection() -> NSInteger
    func numberOfItemsForSection(section: NSInteger) -> NSInteger
}
