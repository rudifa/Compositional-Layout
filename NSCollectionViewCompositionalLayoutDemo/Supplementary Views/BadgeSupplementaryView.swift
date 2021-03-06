//
//  BadgeSupplementaryView.swift
//  NSCollectionViewCompositionalLayoutDemo
//
//  Created by Andrei Hogea on 08/08/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

class BadgeSupplementaryView: UICollectionReusableView {

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.textAlignment = .center
        label.textColor = .white
        backgroundColor = .red
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height/2
        layer.masksToBounds = true
    }
}
