//
//  ViewState.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 31/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation

enum ViewState {
    case empty
    case loading
    case error(description: String)
    case showing
}
