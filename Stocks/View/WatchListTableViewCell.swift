//
//  WatchListTableViewCell.swift
//  Stocks
//
//  Created by jonas silva on 06/07/2021.
//

import UIKit

protocol WatchListTableViewCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

class WatchListTableViewCell: UITableViewCell {
    static let identifier = "WatchListTableViewCell"
    static let preferedHeight: CGFloat = 60
    
    weak var delegate: WatchListTableViewCellDelegate?
    
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String
        let changeColor: UIColor // red or green
        let changePercentage: String
        let chartViewmodel: StockChartView.ViewModel
    }
    
    // SYMBOL LABEL
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
        //NAME LABEL
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    // PRICE LABEL
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    //CHANGE LABEL
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        return label
    }()
    
    // MINI CHART VIEW
    private let miniChartView: StockChartView  = {
        let chart = StockChartView()
        chart.isUserInteractionEnabled = false
        chart.clipsToBounds = true
        return chart
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews(symbolLabel,nameLabel,miniChartView,priceLabel,changeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbolLabel.sizeToFit()
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        changeLabel.sizeToFit()
        
        let yStart: CGFloat = (contentView.height - symbolLabel.height - nameLabel.height)/2
        
        symbolLabel.frame = CGRect(x: separatorInset.left, y: yStart, width: symbolLabel.width, height: symbolLabel.height)
        
        nameLabel.frame = CGRect(x: separatorInset.left, y: symbolLabel.bottom, width: nameLabel.width, height: nameLabel.height)
                
        let currentWidth = max(max(priceLabel.width, changeLabel.width), WatchListViewController.maxChangeWidth)
        
        if currentWidth > WatchListViewController.maxChangeWidth {
            WatchListViewController.maxChangeWidth = currentWidth
            delegate?.didUpdateMaxWidth()
        }
        
        priceLabel.frame = CGRect(x: contentView.width - 10 - currentWidth, y:(contentView.height - priceLabel.height - changeLabel.height)/2 , width: priceLabel.width, height: priceLabel.height)
        
        miniChartView.frame = CGRect(x: priceLabel.left - (contentView.width/3) - 5, y: 6, width: contentView.width/3, height: contentView.height - 12)
        
        changeLabel.frame = CGRect(x: contentView.width - 10 - currentWidth, y:priceLabel.bottom , width: currentWidth, height: changeLabel.height)


    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
        //CONFIGURE CHART
        miniChartView.configure(with: viewModel.chartViewmodel)
        
        
    }
    
}
