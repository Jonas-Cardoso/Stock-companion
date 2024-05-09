//
//  StockDetailHeaderView.swift
//  Stocks
//
//  Created by jonas silva on 08/07/2021.
//

import UIKit

class StockDetailHeaderView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private var metricViewModel: [MetricCollectionViewCell.ViewModel] = []
        
    // chart view
    private let chartView = StockChartView()
    // collection view
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MetricCollectionViewCell.self, forCellWithReuseIdentifier: MetricCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        // register cells
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubviews(chartView,collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = CGRect(x: 0, y: 0, width: width, height: height - 100)
        collectionView.frame = CGRect(x: 0, y: height-100, width: width, height: 100)
    }
    
    func configure(chartViewModel: StockChartView.ViewModel, metricViewModels: [MetricCollectionViewCell.ViewModel]) {
        
        // update chart
        chartView.configure(with: chartViewModel)
        self.metricViewModel = metricViewModels
        collectionView.reloadData()
        
    }
    // collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metricViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = metricViewModel[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCollectionViewCell.identifier, for: indexPath) as? MetricCollectionViewCell else {fatalError()}
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/2, height: 100/3)
    }
    
}
