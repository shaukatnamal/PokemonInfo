//
//  RestClient.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
import Alamofire
class RestClient: Api {
	static func fetchPokemon( completion: @escaping (AFResult<BaseList>) -> Void) {
		let decoder = JSONDecoder()
		let context = CoreDataHelper.sharedInstance.persistentContainer.viewContext
		decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = context
		AF.request(Router.Pokemon)
			.responseDecodable(decoder: decoder) {
				(response: AFDataResponse<BaseList>) in
				completion(response.result)
		}
	}

	static func fetchPokemonAbilites(url:String,completion: @escaping (AFResult<BaseDetail>) -> Void) {
		let decoder = JSONDecoder()
		let context = CoreDataHelper.sharedInstance.persistentContainer.viewContext
		decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = context
		AF.request(Router.Abilities(url))
			.responseDecodable(decoder: decoder) {
				(response: AFDataResponse<BaseDetail>) in
				completion(response.result)
		}
	}

}
