//
//  PokemonDetailViewController.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
import UIKit
class PokemonDetailViewController: BaseViewController ,BaseViewControllerProtocol
{
	// MARK: -IBOulets
	@IBOutlet weak var pokoImageView: UIImageView!
	@IBOutlet weak var nameHeader: UILabel!
	@IBOutlet weak var abilityHeader: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var abilityLabel: UILabel!
	
	var sourceViewModel :PokemonCellViewModel!
	private var pokemonDetailViewModel = PokemonDetailViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		bindViewModel()
		setupView()
	}

	func bindViewModel() {
		pokemonDetailViewModel.changeHandler = {
			[unowned self] change in
			switch change {
				case .error(let message):
					self.showToastMsg(msg:message)
					break
				case .loaderEnd:
					self.removeActivityIndicator()
					break
				case .loaderStart:
					self.showActivityIndicator(onView: self.view)
					break
				case .updateDataModel:
					self.populateViews()
					break
			}
		}
	}

	func setupView() {

		let name = sourceViewModel.pokemon.name ?? ""
		let url = sourceViewModel.pokemon.url ?? ""
		pokemonDetailViewModel.startFetchingDetail(url: url,pokemonName:name)
	}

	func populateViews()
	{
		nameHeader.text = "Name:"
		abilityHeader.text = "Abilities:"
		nameLabel.text! = (sourceViewModel.pokemon.name)!
		let abilities = pokemonDetailViewModel.viewModel.value
		//print(abilitiesViewModels)
		for ability in abilities
		{
			switch ability {
				case .normal(let viewModel):
					abilityLabel.text! += (viewModel.abilityItem.ability?.abilityName)! + " "
					if let imageURL = URL(string: sourceViewModel.pokemon.imgUrl!){
						pokoImageView.af.setImage(withURL: imageURL)
				}
				case .empty:
					print("empty")
			}
		}
	}

}
