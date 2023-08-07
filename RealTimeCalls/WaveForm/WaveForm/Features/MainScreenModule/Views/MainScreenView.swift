//
//  FilterView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

private enum Constants {
    static let numerOfSections: Int = 1
}

private extension Spacer {
    var space44: CGFloat { 44 }
    var itemSize: CGSize { CGSize(width: 226, height: 326) }
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
        label.textColor = Color.current.text.blackColor
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(
            top: .zero,
            left: UIScreen.main.bounds.width / 2 - spacer.itemSize.width / 2,
            bottom: .zero,
            right: UIScreen.main.bounds.width / 2 - spacer.itemSize.width / 2
        )
        layout.itemSize = spacer.itemSize
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
        label.textColor = Color.current.text.blackColor
        return label
    }()
    
    private lazy var allContactsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular18
        label.textColor = Color.current.text.lightBlueColor
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
        backgroundColor = Color.current.background.mainColor
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
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacer.space32)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(spacer.itemSize.height)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(spacer.space44)
            make.leading.equalToSuperview().inset(spacer.space16)
            make.trailing.lessThanOrEqualTo(allContactsLabel.snp.leading).offset(spacer.space16)
        }
        
        allContactsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(spacer.space16).priority(.high)
            make.centerY.equalTo(recentLabel)
        }
        
        firstRecentContact.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(spacer.space40)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        secondRecentContact.snp.makeConstraints { make in
            make.top.equalTo(firstRecentContact.snp.bottom).offset(spacer.space16)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
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
        return spacer.itemSize
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
