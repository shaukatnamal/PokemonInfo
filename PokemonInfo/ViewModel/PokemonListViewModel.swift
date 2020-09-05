//
//  PokemonListViewModel.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
class PokemonListViewModel:BaseViewModel
{
	var changeHandler: ((BaseViewModelChange) -> Void)?
	enum ViewModelType {
		case normal(cellViewModel: PokemonCellViewModel)
		case empty
	}

	let viewModel = Bindable([ViewModelType]())
	func startFetchingData() {
		if(!isConnectedToInternet())
		{
			fetchOfflineData()
			self.emit(.error(message: "server is not reachable!"))
			return
		}
		//start network task
		emit(.loaderStart)
		RestClient.fetchPokemon(){
			result in
			switch result {
				case .success(let response):
					guard response.results!.count > 0 else {
						self.viewModel.value = [.empty]
						return
					}
					self.viewModel.value = response.results!.compactMap {
						.normal(cellViewModel: $0 as PokemonCellViewModel)
					}
					//save results coredata
					CoreDataHelper.sharedInstance.saveResults(response.results!)
					self.emit(.updateDataModel)
					self.emit(.loaderEnd)
				case .failure(let error):
					self.emit(.error(message: error.asAFError.debugDescription))
					print(error.localizedDescription)
			}
		}
	}

	func fetchOfflineData()
	{
		self.emit(.loaderEnd)
		let results = CoreDataHelper.sharedInstance.retrieveResults()
		if(results != nil)
		{
			if (results!.count > 0)
			{
				self.viewModel.value = results!.compactMap {
					.normal(cellViewModel: $0 as PokemonCellViewModel)
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
protocol PokemonCellViewModel {
	var pokemon: Results  {
		get
	}

}
extension Results: PokemonCellViewModel {
	var pokemon: Results {
		return self
	}

}
