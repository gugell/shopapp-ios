//
//  UIView+LoadFromNib.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/11/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

extension UIView {    
    func loadFromNib(with nibName: String? = nil) {
        let view = Bundle.main.loadNibNamed(nibName ?? nameOfClass, owner: self)?.last as! UIView
        addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
