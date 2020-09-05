//
//  BaseList.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//


class BaseList : Decodable {
	var results : [Results]?
	var next : String?
}
