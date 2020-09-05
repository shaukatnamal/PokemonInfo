//
//  Util.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//

import Alamofire


func isConnectedToInternet() -> Bool {
	return NetworkReachabilityManager()?.isReachable ?? false
}

