//
//  PokemonListViewController.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
import UIKit
import AlamofireImage
class PokemonListViewController: BaseViewController ,BaseViewControllerProtocol,UITableViewDataSource,UITableViewDelegate {
	@IBOutlet weak var tableView: UITableView!
	
	//viewmodel
	var pokomenListViewModel = PokemonListViewModel()
	var refreshControl = UIRefreshControl()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		bindViewModel()
		setupView()


	}

	func bindViewModel() {
		pokomenListViewModel.changeHandler = {
			[unowned self] change in
			switch change {
				case .error(let message):
					self.endLoadingIndicators()
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						self.showErrorPopUp(msg :message)
					}
					break
				case .loaderEnd:
					self.endLoadingIndicators()
					break
				case .loaderStart:
					if(!self.refreshControl.isRefreshing)
					{
						self.showActivityIndicator(onView: self.view)
					}
					break
				case .updateDataModel:
					self.endLoadingIndicators()
					self.tableView.reloadData()
					break
			}
		}
	}

	func setupView() {
	

		if #available(iOS 11, *) {}
		else {
			self.edgesForExtendedLayout = []
		}
		self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
		self.tableView.addSubview(refreshControl)
		self.pokomenListViewModel.startFetchingData()
	}

	@objc func refresh(sender:AnyObject)
	{
		self.pokomenListViewModel.startFetchingData()
	}

	private func endLoadingIndicators()
	{
		self.refreshControl.endRefreshing()
		self.removeActivityIndicator()
	}

	public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifier.showDetails {
			performSegueForShowDetails(segue: segue)
		}
	}

	private func performSegueForShowDetails(segue :UIStoryboardSegue) {
		guard let indexPath = self.tableView.indexPathForSelectedRow else {
			fatalError("indexPath not found")
		}
		switch pokomenListViewModel.viewModel.value[indexPath.row] {
			case .normal(let sourceViewModel):
				let detailsVC = segue.destination as! PokemonDetailViewController
				detailsVC.sourceViewModel = sourceViewModel
				return
			case .empty:
				print("empty")
				return
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pokomenListViewModel.viewModel.value.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch pokomenListViewModel.viewModel.value[indexPath.row] {
			case .normal(let viewModel):
				guard let cell  = tableView.dequeueReusableCell(withIdentifier: PokemonStoreTableViewCell.Identifier) as? PokemonStoreTableViewCell else {
					return UITableViewCell()
				}
				//assign dummy image url to the model
				viewModel.pokemon.imgUrl = Url.pokoImageBaseUrl + "\(indexPath.row+1).png"
				cell.viewModel = viewModel
				return cell
			case .empty:
				let cell = UITableViewCell()
				cell.isUserInteractionEnabled = false
				cell.textLabel?.text = "No data available"
				return cell
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Do here
		performSegue(withIdentifier: "detailViewController", sender: nil)
		print("You tapped cell number \(indexPath.row).")
	}

}
class PokemonStoreTableViewCell: UITableViewCell {
	static let Identifier = Cells.pokemonStoreTableViewCell
	@IBOutlet  var pokoImage: UIImageView!
	@IBOutlet  var name: UILabel!
	var viewModel: PokemonCellViewModel? {
		didSet {
			bindViewModel()
		}
	}

	private func bindViewModel() {
		if let imageURL = URL(string:(viewModel?.pokemon.imgUrl)!)
		{
			pokoImage.af.setImage(withURL: imageURL)
		}
		name?.text = viewModel?.pokemon.name
	}

}
