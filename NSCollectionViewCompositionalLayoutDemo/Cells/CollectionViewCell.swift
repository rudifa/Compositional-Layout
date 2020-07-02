//
//  UICollectionViewCell.swift
//  NSCollectionViewCompositionalLayoutDemo
//
//  Created by Andrei Hogea on 07/08/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 10

        label.textAlignment = .center
        label.font = label.font.withSize(14)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
