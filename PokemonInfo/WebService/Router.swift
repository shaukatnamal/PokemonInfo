//
//  Router.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//
import Alamofire
enum Router: URLRequestConvertible {
	enum Constants {
		static let baseURL = Url.baseURLAPI
		static let authenticationToken = "testauthtoken"
		static let limit = 20
		static let offset = 0
	}

	case Pokemon
	case Next(String)
	case Ditto(String)
	case Abilities(String)
	var method: Alamofire.HTTPMethod {
		switch self {
			case .Pokemon:
				return .get
			case .Next:
				return .get
			case .Ditto:
				return .get
			case .Abilities:
				return .get
		}
	}

	var path: String {
		switch self {
			case .Pokemon:
				let path = Constants.baseURL + "?limit=\(Constants.limit)&offset=\(Constants.offset)"
				return path
			case .Next(let url):
				return url
			case .Ditto(let url):
				return url
			case .Abilities(let url):
				return url
		}
	}

	func asURLRequest() throws -> URLRequest {
		print(path)
		let url = try path.asURL()
		var request = URLRequest(url: url)
		print(request)
		request.httpMethod = method.rawValue
		request.setValue(Constants.authenticationToken, forHTTPHeaderField: "Authorization")
		request.timeoutInterval = TimeInterval(10 * 1000)
		return try URLEncoding.default.encode(request, with: [:])
	}

}
