//
//  OtherView.swift
//  BStest
//
//  Created by Fabio Codiglioni on 01/12/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import UIKit
import Tempura
import PinLayout


struct OtherViewModel: ViewModelWithState {
    let counter: String
    
    init(state: CounterState) {
        self.counter = "\(state.counter)"
    }
}


class OtherView: UIView, ViewControllerModellableView {
    var label = UILabel()
    
    func setup() {
        self.addSubview(self.label)
    }
    
    func style() {
        self.backgroundColor = .systemBackground
        self.label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize + 32)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.sizeToFit()
        self.label.pin.center()
    }
    
    func update(oldModel: OtherViewModel?) {
        guard let model = self.model else { return }
        self.label.text = model.counter
    }
}


class OtherViewController: ViewController<OtherView> {
    override func viewDidLoad() {
        guard let navigationController = self.presentingViewController as? UINavigationController else { return }
        navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    override func setupInteraction() {

    }
}


extension OtherViewController: RoutableWithConfiguration {
    var routeIdentifier: RouteElementIdentifier {
        Screen.other.rawValue
    }
    
    var navigationConfiguration: [NavigationRequest : NavigationInstruction] {
        [
            .hide(Screen.other): .pop
        ]
    }
}
