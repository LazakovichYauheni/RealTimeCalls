//
//  FilterView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit
import CollectionViewPagingLayout

private enum Constants {
    static let numerOfSections: Int = 1
}

private extension Spacer {
    var space44: CGFloat { 44 }
    var itemSize: CGSize { CGSize(width: 226, height: 386) }
}

protocol MainScreenViewEventsRespondable {
    func didItemTapped(index: Int, cell: MainScreenCollectionViewCell)
    func didAllContactsTapped()
}

public final class MainScreenView: UIView {
    private lazy var scrollView: CustomScrollView = {
        let scroll = CustomScrollView()
        scroll.decelerationRate = .fast
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var containerView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium24
        label.text = "Favorites"
        label.textColor = .black
        return label
    }()
    
    private lazy var containerFavoritesView = UIView()
    
    private lazy var containerFavoritesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noFavorites")
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var memeCollectionView: UICollectionView = {
        let layout = CollectionViewPagingLayout()
        layout.delegate = self
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(MainScreenCollectionViewCell.self, forCellWithReuseIdentifier: "cellReuseIdentifier")
        return collection
    }()
    
    private lazy var recentLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium24
        label.text = "Recent"
        label.textColor = .black
        return label
    }()
    
    private lazy var allContactsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular18
        label.textColor = UIColor(red: 0 / 255, green: 143 / 255, blue: 219 / 255, alpha: 1)
        label.isUserInteractionEnabled = true
        label.text = "All"
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allContactsTapped)))
        return label
    }()
    
    private lazy var recentsContainerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        return stack
    }()
    
    private lazy var emptyRecentsView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(named: "noRecents")
        return imageView
    }()
    
    private lazy var firstRecentContact = MainScreenContactView()
    private lazy var secondRecentContact = MainScreenContactView()
    
    private lazy var responder = Weak(firstResponder(of: MainScreenViewEventsRespondable.self))
    private var cellViewModels: [MainScreenCollectionViewCell.ViewModel] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = UIColor(red: 235 / 255, green: 241 / 255, blue: 245 / 255, alpha: 1)
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(memeCollectionView)
        containerView.addSubview(recentLabel)
        containerView.addSubview(allContactsLabel)
        containerView.addSubview(recentsContainerStackView)
        recentsContainerStackView.addArrangedSubview(emptyRecentsView)
        recentsContainerStackView.addArrangedSubview(firstRecentContact)
        recentsContainerStackView.addArrangedSubview(secondRecentContact)
    }
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacer.space32)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        memeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(spacer.itemSize.height)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(memeCollectionView.snp.bottom).offset(spacer.space24)
            make.leading.equalToSuperview().inset(spacer.space16)
            make.trailing.lessThanOrEqualTo(allContactsLabel.snp.leading).offset(spacer.space16)
        }
        
        allContactsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(spacer.space16).priority(.high)
            make.centerY.equalTo(recentLabel)
        }
        
        recentsContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(spacer.space40)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.bottom.equalToSuperview()
        }
        
        emptyRecentsView.snp.makeConstraints { make in
            make.size.equalTo(150)
        }
    }
    
    @objc private func allContactsTapped() {
        responder.object?.didAllContactsTapped()
    }
}

extension MainScreenView {
    struct ViewModel {
        let cellViewModels: [MainScreenCollectionViewCell.ViewModel]
        let recentContactViewModels: [MainScreenContactView.ViewModel]
    }
    
    func configure(viewModel: MainScreenView.ViewModel) {
        if viewModel.cellViewModels.isEmpty {
            emptyImageView.isHidden = false
            memeCollectionView.isHidden = true
        } else {
            cellViewModels = viewModel.cellViewModels
            memeCollectionView.reloadData()
            memeCollectionView.performBatchUpdates({ [weak self] in
                self?.memeCollectionView.collectionViewLayout.invalidateLayout()
            })
        }
        
        if viewModel.recentContactViewModels.isEmpty {
            emptyRecentsView.isHidden = false
            firstRecentContact.isHidden = true
            secondRecentContact.isHidden = true
        } else {
            firstRecentContact.configure(with: viewModel.recentContactViewModels[0])
            secondRecentContact.configure(with: viewModel.recentContactViewModels[1])
        }
    }
}

extension MainScreenView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? MainScreenCollectionViewCell
        else { return }
        responder.object?.didItemTapped(index: indexPath.row, cell: cell)
    }

    private func indexPathForVisiblePoint(collection: UICollectionView) -> IndexPath? {
        var visibleRect = CGRect()
        visibleRect.origin = collection.contentOffset
        visibleRect.size = collection.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collection.indexPathForItem(at: visiblePoint)
    }
}

extension MainScreenView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        Constants.numerOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellReuseIdentifier", for: indexPath) as? MainScreenCollectionViewCell,
            let item = cellViewModels[safe: indexPath.row]
        else { return UICollectionViewCell() }
        cell.configure(with: item)
        
        return cell
    }
}

extension MainScreenView: CollectionViewPagingLayoutDelegate {
    public func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {
        guard
            let selectedCell = memeCollectionView.cellForItem(at: IndexPath(row: currentPage, section: .zero)) as? MainScreenCollectionViewCell
        else { return }
        memeCollectionView.visibleCells.forEach { cell in
            guard let cell = cell as? MainScreenCollectionViewCell else { return }
            if selectedCell != cell {
                cell.changeAppearance(isSelected: false)
            }
        }
        selectedCell.changeAppearance(isSelected: true)
    }
}
