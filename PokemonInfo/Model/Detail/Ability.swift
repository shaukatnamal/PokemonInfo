//
//  Ability.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
import CoreData
class Ability: NSManagedObject, Decodable {
	// MARK: - CodingKeys
	enum CodingKeys: String, CodingKey {
		case name
		case url
		case pokemon
	}

	var imgUrl: String?
	// MARK: - Core Data Managed Object
	@NSManaged var pokemon: String?
	@NSManaged var abilityName: String?
	@NSManaged var url: String?
	// MARK: - Decodable
	required convenience init(from decoder: Decoder) throws {
		guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
			let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
			let entity = NSEntityDescription.entity(forEntityName: Entity.ability, in: managedObjectContext) else {
				fatalError("failed to decode result")
		}
		self.init(entity: entity, insertInto: managedObjectContext)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.url = try container.decodeIfPresent(String.self, forKey: .url)
		self.abilityName = try container.decodeIfPresent(String.self, forKey: .name)
	}

	// MARK: - Encodable
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(url, forKey: .url)
		try container.encode(abilityName, forKey: .name)
		try container.encode(pokemon, forKey: .pokemon)
	}

}
