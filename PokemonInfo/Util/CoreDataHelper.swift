//
//  CoreDataHelper.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
import UIKit
import CoreData
open class CoreDataHelper: NSObject {
	public static let sharedInstance = CoreDataHelper()
	private override init() {
	}

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "PokemonInfo")
		container.loadPersistentStores(completionHandler: {
			(storeDescription, error) in
			if let error = error as NSError? {

				//fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	func getContext() -> NSManagedObjectContext? {
		guard (UIApplication.shared.delegate as? AppDelegate) != nil else {
			return nil
		}
		return persistentContainer.viewContext
	}

	func retrieveResults() -> [Results]? {
		guard let context = getContext() else {
			return nil
		}
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.results)
		do {
			return try (context.fetch(fetchRequest) as? [Results])
		}
		catch let error as NSError {
			print("Retrieiving results failed. \(error): \(error.userInfo)")
			return nil
		}
	}

	func saveResults(_ results: [Results]) {
		guard let context = getContext() else {
			return
		}
		//remove existing data
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.results)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		do {
			try context.execute(deleteRequest)
		}
		catch let error as NSError {
			print("Error deleting: \(error)")
		}
		// add new data
		for result in results
		{
			context.insert(result)
		}
		do {
			try context.save()
			print("Success")
		}
		catch {
			print("Error saving: \(error)")
		}
	}

	func retrieveAbilities(pokemonName:String) -> [Ability]? {
		guard let context = getContext() else {
			return nil
		}
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.ability)
		let predicate = NSPredicate(format: "pokemon = %@", argumentArray: [pokemonName])
		fetchRequest.predicate = predicate
		do {
			return try (context.fetch(fetchRequest) as? [Ability])
		}
		catch let error as NSError {
			print("Retrieiving ability failed. \(error): \(error.userInfo)")
			return nil
		}
	}

	func saveAbilities(_ abilities: [Abilities],pokemonName:String) {
		guard let context = getContext() else {
			return
		}
		for abilityItem in abilities
		{
			let ability = abilityItem.ability
			if(ability != nil)
			{
				ability!.pokemon = pokemonName
				context.insert(ability!)
			}
		}
		do {
			try context.save()
			print("Success")
		}
		catch {
			print("Error saving: \(error)")
		}
	}

}
