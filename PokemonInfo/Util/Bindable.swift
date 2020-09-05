//
//  Bindable.swift
//  PokemonInfo
//
//  Created by SA on 05/09/2020.
//  Copyright © 2020 Shaukat Ali. All rights reserved.
//

class Bindable<T> {
	typealias Listener = ((T) -> Void)
	var listener: Listener?

	var value: T {
		didSet {
			listener?(value)
		}
	}

	init(_ v: T) {
		self.value = v
	}



}
