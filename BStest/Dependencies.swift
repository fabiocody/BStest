//
//  Dependencies.swift
//  BStest
//
//  Created by Fabio Codiglioni on 21/11/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation
import Katana
import Tempura
import Hydra


final class DependenciesContainer: NavigationProvider {
    let promisableDispatch: PromisableStoreDispatch
    var getAppState: () -> CounterState
    var navigator: Navigator = Navigator()
    let randomGenerator = RandomGenerator()
    
    var getState: () -> State {
        return self.getAppState
    }

    init(dispatch: @escaping PromisableStoreDispatch, getAppState: @escaping () -> CounterState) {
        self.promisableDispatch = dispatch
        self.getAppState = getAppState
    }
    
    convenience init(dispatch: @escaping PromisableStoreDispatch, getState: @escaping GetState) {
        let getAppState: () -> CounterState = {
            guard let state = getState() as? CounterState else {
                fatalError("Wrong State Type")
            }
            return state
        }
        self.init(dispatch: dispatch, getAppState: getAppState)
    }
}


final class RandomGenerator {
    func randint(start: Int, end: Int) -> Promise<Int> {
        return Promise<Int>(in: .background) { resolve, reject, status in
            resolve(Int.random(in: start..<end))
        }
    }
}
