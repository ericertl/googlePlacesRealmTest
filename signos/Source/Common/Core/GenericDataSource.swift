//
//  GenericDataSource.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import Foundation

class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}
