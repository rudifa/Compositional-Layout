//
//  ViewController.swift
//  NSCollectionViewCompositionalLayoutDemo
//
//  Created by Andrei Hogea on 30/07/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var collectionView: UICollectionView!

    private var sectionColors: [UIColor] = [
        .systemRed,
        .systemBlue,
        .systemGreen,
        .systemTeal,
        .systemYellow,
        .systemGray,
    ]

    var itemCount = 3

    lazy var plusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray // uncomment for visual debugging
        let large = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "plus")?.withConfiguration(large), for: .normal)
        button.tintColor = .white
        button.sizeToFit()
        button.addTarget(self, action: #selector(plusButtonTap), for: .touchUpInside)
        button.isHidden = false
        return button
    }()

    lazy var minusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray // uncomment for visual debugging
        let large = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "minus")?.withConfiguration(large), for: .normal)
        button.tintColor = .white
        button.sizeToFit()
        button.addTarget(self, action: #selector(minusButtonTap), for: .touchUpInside)
        button.isHidden = false
        return button
    }()

    @objc func minusButtonTap(_: UIButton) {
        // printClassAndFunc()
        if itemCount > 0 {
            itemCount -= 1
            collectionView.reloadData()
        }
    }

    @objc func plusButtonTap(_: UIButton) {
        // printClassAndFunc()
        itemCount += 1
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionView()

        view.addSubview(plusButton)
        view.addSubview(minusButton)

        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            plusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            minusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
            minusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func makeCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .lightGray
        collectionView.dataSource = self
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 250),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
        ])

        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: "CollectionViewCell")
    }

    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(76),
                                              heightDimension: .absolute(76))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                        leading: 5,
                                                        bottom: 5,
                                                        trailing: 5)

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
        return layout
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

        cell.label.text = indexPath.section.description + " - " + indexPath.item.description
        cell.backgroundColor = sectionColors[indexPath.section]

        return cell
    }
}
