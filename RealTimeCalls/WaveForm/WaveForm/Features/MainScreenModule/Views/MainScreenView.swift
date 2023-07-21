//
//  FilterView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

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
    
    private lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: .zero, left: UIScreen.main.bounds.width / 2 - 226 / 2, bottom: .zero, right: UIScreen.main.bounds.width / 2 - 226 / 2)
        layout.itemSize = CGSize(width: 226, height: 326)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = .fast
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
    
    private lazy var firstRecentContact = MainScreenContactView()
    private lazy var secondRecentContact = MainScreenContactView()
    private var previousIndexPath: IndexPath = [0, 1]
    
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
        containerView.addSubview(collectionView)
        containerView.addSubview(recentLabel)
        containerView.addSubview(allContactsLabel)
        containerView.addSubview(firstRecentContact)
        containerView.addSubview(secondRecentContact)
    }
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
            make.leading.equalToSuperview().inset(0)
            make.trailing.equalToSuperview().inset(0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(326)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(44)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(allContactsLabel.snp.leading).offset(16)
        }
        
        allContactsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16).priority(.high)
            make.centerY.equalTo(recentLabel)
        }
        
        firstRecentContact.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        secondRecentContact.snp.makeConstraints { make in
            make.top.equalTo(firstRecentContact.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc private func allContactsTapped() {
        responder.object?.didAllContactsTapped()
    }
}

extension MainScreenView {
    struct ViewModel {
        let cellViewModels: [MainScreenCollectionViewCell.ViewModel]
        let firstRecentContactViewModel: MainScreenContactView.ViewModel
        let secondRecentContactViewModel: MainScreenContactView.ViewModel
    }
    
    func configure(viewModel: MainScreenView.ViewModel) {
        cellViewModels = viewModel.cellViewModels
        firstRecentContact.configure(with: viewModel.firstRecentContactViewModel)
        secondRecentContact.configure(with: viewModel.secondRecentContactViewModel)
    }
}

extension MainScreenView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 226, height: 326)
    }
}

extension MainScreenView: UICollectionViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard
            let indexPath = indexPathForVisiblePoint(collection: collectionView),
            let selectedCell = collectionView.cellForItem(at: indexPath) as? MainScreenCollectionViewCell
        else { return }

        collectionView.visibleCells.forEach { cell in
            guard let cell = cell as? MainScreenCollectionViewCell else { return }
            if selectedCell != cell {
                cell.changeAppearance(isSelected: false)
            }
        }
        selectedCell.changeAppearance(isSelected: true)
    }
    
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
        1
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
