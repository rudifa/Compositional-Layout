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

    override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionView()
    }

    enum Section: Int, CaseIterable {
        case daysOfWeek // "Mon"..."Sun"
        case daysOfMonth // 1...31
        case hoursOfDay // 00:00..23:00

        /// Failable initializer, returns a valid enum value if index is valid, otherwise returns nil
        ///
        /// - Parameter index: to convert into enum value
        init?(_ index: Int) {
            if Section.allCases.indices.contains(index) {
                self = Section.allCases[index]
            } else {
                return nil
            }
        }
    }

    struct SectionNumbers {
        let cellsPerRow: Int
        let rows: Int
        let cellRectAspectRatio: CGFloat
        var numberOfItemsInSection: Int { cellsPerRow * rows }
    }

    /// Returns sizes and numbers that define the layout for the section
    /// - Parameter section
    func sectionNumbers(section: Int) -> SectionNumbers {
        switch Section(section) {
        case .daysOfWeek?: return SectionNumbers(cellsPerRow: 7, rows: 1, cellRectAspectRatio: 0.8)
        case .daysOfMonth?: return SectionNumbers(cellsPerRow: 7, rows: 6, cellRectAspectRatio: 1.0)
        case .hoursOfDay?: return SectionNumbers(cellsPerRow: 6, rows: 4, cellRectAspectRatio: 0.8)
        default: fatalError()
        }
    }

    private func makeCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .orange
        collectionView.dataSource = self
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),

            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            collectionView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8 * 9.0 / 16.0),
        ])

        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(BadgeSupplementaryView.self,
                                forSupplementaryViewOfKind: "badge",
                                withReuseIdentifier: "BadgeSupplementaryView")
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: "header",
                                withReuseIdentifier: "HeaderSupplementaryView")

        printClassAndFunc(info: "view.frame.size= \(view.frame.size)")
        printClassAndFunc(info: "collectionView.contentSize= \(collectionView.contentSize)")
    }

    private func makeLayout() -> UICollectionViewLayout {
        printClassAndFunc(info: "")

        let layout = UICollectionViewCompositionalLayout {
            // this closure is called for each section, to define its layout
            (section: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            self.printClassAndFunc(info: "section= \(section)")

            let sectionNumbers = self.sectionNumbers(section: section)

            // this prepares a grid of rectangles for all sections, with specified aspectRatio
            let itemFractionalWidth = 1.0 / CGFloat(sectionNumbers.cellsPerRow)
            let itemFractionalHeight = itemFractionalWidth * sectionNumbers.cellRectAspectRatio

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidth),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(itemFractionalHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
            // ^^^ section.contentInsets reduce the section dimensions available for groups (rows)

            let size = layoutEnvironment.container.contentSize
            let aspectRatio = size.width / size.height
            self.printClassAndFunc(info: "layoutEnvironment.container.contentSize \(layoutEnvironment.container.contentSize) aspectRatio= \(aspectRatio)")
            // self.printClassAndFunc(info: "layoutEnvironment.container.effectiveContentSize \(layoutEnvironment.container.effectiveContentSize)")
            // self.printClassAndFunc(info: "self.collectionView.visibleSize \(self.collectionView.visibleSize)")

            return section
        }
        return layout
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionNumbers(section: section).numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

        cell.label.text = indexPath.section.description + "." + indexPath.item.description
        cell.backgroundColor = sectionColors[indexPath.section]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case "header":
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "HeaderSupplementaryView",
                                                                             for: indexPath) as! HeaderSupplementaryView
            headerView.label.text = "This is a header"

            return headerView
        case "badge":
            let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: "BadgeSupplementaryView",
                                                                            for: indexPath) as! BadgeSupplementaryView
            badgeView.label.text = indexPath.section.description

            return badgeView
        default:
            print(kind)
            return UICollectionReusableView()
        }
    }
}
