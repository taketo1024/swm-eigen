//
//  Destructor.swift
//  
//
//  Created by Taketo Sano on 2021/06/11.
//

internal final class Destructor {
    private let destructor: () -> Void
    init(_ destructor: @escaping () -> Void) {
        self.destructor = destructor
    }
    
    deinit {
        destructor()
    }
}
