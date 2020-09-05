//
//  PokemonDetailViewModel.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
class PokemonDetailViewModel:BaseViewModel
{
	enum ViewModelType {
		case normal(viewModel: AbilitiesViewModel)
		case empty
	}

	let viewModel = Bindable([ViewModelType]())
	var changeHandler: ((BaseViewModelChange) -> Void)?
	func startFetchingDetail(url:String,pokemonName:String) {
		if(!isConnectedToInternet())
		{
			fetchOfflineData(pokemonName: pokemonName)
			self.emit(.error(message: "server is not reachable!"))
			return
		}
		//start network taask
		emit(.loaderStart)
		RestClient.fetchPokemonAbilites(url: url){
			result in
			switch result {
				case .success(let response):
					guard response.abilities!.count > 0 else {
						self.viewModel.value = [.empty]
						return
					}
					self.viewModel.value = response.abilities!.compactMap {
						.normal(viewModel: $0 as AbilitiesViewModel)
					}
					//save data to coredata
					CoreDataHelper.sharedInstance.saveAbilities(response.abilities!,pokemonName:pokemonName)
					self.emit(.updateDataModel)
					self.emit(.loaderEnd)
				case .failure(let error):
					self.emit(.error(message: error.asAFError.debugDescription))
					print(error.localizedDescription)
			}
		}
	}

	func fetchOfflineData(pokemonName:String)
	{
		self.emit(.loaderEnd)
		let abilities = CoreDataHelper.sharedInstance.retrieveAbilities(pokemonName:pokemonName)
		if(abilities != nil)
		{
			if (abilities!.count > 0)
			{
				var abilitiesContainer = [Abilities]()
				for ability in abilities!
				{
					let abs = Abilities(ability: ability)
					abilitiesContainer.append(abs)
				}
				self.viewModel.value = abilitiesContainer.compactMap {
					.normal(viewModel: $0 as AbilitiesViewModel)
				}
			}
			else {
				self.viewModel.value = [.empty]
			}
			self.emit(.updateDataModel)
			self.emit(.loaderEnd)
		}
	}

	func emit(_ change: BaseViewModelChange) {
		changeHandler?(change)
	}

}
protocol AbilitiesViewModel {
	var abilityItem: Abilities  {
		get
	}

}
extension Abilities: AbilitiesViewModel {
	var abilityItem: Abilities {
		return self
	}

}
