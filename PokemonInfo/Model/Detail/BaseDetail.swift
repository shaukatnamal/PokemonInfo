//
//  BaseDetail.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//


struct BaseDetail : Decodable {
	var abilities : [Abilities]?
	var base_experience : Int?
	var name : String?
	var order : Int?
	var weight : Int?
}

struct Abilities : Decodable {
	var ability : Ability?

	init(ability: Ability) {
		self.ability = ability
	}
}
