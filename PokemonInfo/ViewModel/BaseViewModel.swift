//
//  BaseViewModel.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//


protocol BaseViewModel {
	var  changeHandler: ((BaseViewModelChange) -> Void)? {get set}
	func emit(_ change: BaseViewModelChange)
}

enum BaseViewModelChange {
	case loaderStart
	case loaderEnd
	case updateDataModel
	case error(message: String)
}

enum ResponseType {
	case normal(viewModel: Any)
	case empty
}





