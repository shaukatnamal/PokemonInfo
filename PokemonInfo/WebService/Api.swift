//
//  Api.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//

import Alamofire

protocol Api {
	static func fetchPokemon(completion:@escaping (AFResult<BaseList>)->Void)
	static func fetchPokemonAbilites(url: String,completion:@escaping (AFResult<BaseDetail>)->Void)
}
