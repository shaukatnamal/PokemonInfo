//
//  Results.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
import CoreData
class Results: NSManagedObject, Decodable {
	// MARK: - CodingKeys
	enum CodingKeys: String, CodingKey {
		case name
		case url
	}

	var imgUrl: String?
	// MARK: - Core Data Managed Object
	@NSManaged var name: String?
	@NSManaged var url: String?
	// MARK: - Decodable
	required convenience init(from decoder: Decoder) throws {
		guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
			let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
			let entity = NSEntityDescription.entity(forEntityName: Entity.results, in: managedObjectContext) else {
				fatalError("failed to decode result")
		}
		self.init(entity: entity, insertInto: managedObjectContext)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.url = try container.decodeIfPresent(String.self, forKey: .url)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
	}

	// MARK: - Encodable
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(url, forKey: .url)
		try container.encode(imgUrl, forKey: .name)
	}

}
