//
//  PokemonInfoTests.swift
//  PokemonInfoTests
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//

import XCTest
import Alamofire

@testable import PokemonInfo

class PokemonInfoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testAPIBaseURL(){

		let baseURL = Router.Constants.baseURL
		let expectedBaseURL = "https://pokeapi.co/api/v2/pokemon"
		XCTAssertEqual(baseURL, expectedBaseURL, "Base URL mismatched")
	}


	/// This function test webservice in response and returned data validity
	func testWebServiceResponse(){

		let expt = expectation(description: "webservice response")

		RestClient.fetchPokemon(){ result in
			switch result {
				case .success(let response):
					let numberOfResults = response.results?.count ?? 0
					let expetedNumber = 10

					let resultString = response.results?.first?.name ?? ""
					let expectedString = "bulbasaur"

					//test number of item returned
					XCTAssertEqual(numberOfResults, expetedNumber)
					//test return data validity and json decoding
					XCTAssertEqual(resultString, expectedString)

					expt.fulfill()
				case .failure(let error):

					XCTFail(error.errorDescription ?? "http error")
					expt.fulfill()
			}
		}
		waitForExpectations(timeout: 5.0, handler: nil)
	}

    // test Codable NSManagedObject coredata
	func testCodableNSManagedObject()
	{
		let decoder = JSONDecoder()
		decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = CoreDataHelper.sharedInstance.persistentContainer.viewContext
		   AF.request(Router.Pokemon)
			.responseJSON { result in
				do {
					let pokemonList = try  decoder.decode(BaseList.self, from: result.data!)
					let numberOfResults = pokemonList.results?.count ?? 0
					let expetedNumber = 10

					let resultString = pokemonList.results?.first?.name ?? ""
					let expectedString = "bulbasaur"

					//test number of item returned
					XCTAssertEqual(numberOfResults, expetedNumber)
					//test return data validity and json decoding
					XCTAssertEqual(resultString, expectedString)
				}
				catch { XCTFail(error.asAFError?.errorDescription ?? "error") }
		}
	}
}
