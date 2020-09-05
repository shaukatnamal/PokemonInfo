//
//  BaseViewController.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
import UIKit
protocol BaseViewControllerProtocol {
	func bindViewModel()
	func setupView()
}
public class BaseViewController: UIViewController {
	var viewModel: BaseViewModel?
	var loadingIndicator : UIView?

	public func showActivityIndicator(onView : UIView) {
		let activityIndicator = UIActivityIndicatorView.init(style: .gray)
		activityIndicator.startAnimating()
		activityIndicator.center = onView.center
		DispatchQueue.main.async {
			onView.addSubview(activityIndicator)
		}
		loadingIndicator = activityIndicator
	}

	override public func viewDidLayoutSubviews() {
		self.loadingIndicator?.center = self.view.center
	}

	public func removeActivityIndicator() {
		DispatchQueue.main.async {
			self.loadingIndicator?.removeFromSuperview()
			self.loadingIndicator = nil
		}
	}

	public func showErrorPopUp(msg :String)
	{
		let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

	public func showToastMsg(msg :String)
	{
		self.showToast(message: msg , font:UIFont.systemFont(ofSize: 12.0))
	}

}
