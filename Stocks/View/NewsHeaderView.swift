//
//  NewsHeaderView.swift
//  Stocks
//
//  Created by jonas silva on 05/07/2021.
//

import UIKit

protocol NewsHeaderViewDelegate: AnyObject {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

class NewsHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate:NewsHeaderViewDelegate?
    
    static let identifier = "NewsHeaderView"
    static let preferredHeight: CGFloat = 70
    
    struct ViewModel {
        let title: String
        let shouldShowAddButton:Bool
    }
   
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("WatchList", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(label,button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapButton() {
     // call delegate
        delegate?.newsHeaderViewDidTapAddButton(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 14, y: 0, width: contentView.width-20, height: contentView.height)
        button.sizeToFit()
        button.frame = CGRect(x: contentView.width - button.width - 16, y: (contentView.height - button.height)/2, width: button.width+8, height: button.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with viewmodel: ViewModel) {
        label.text = viewmodel.title
        button.isHidden = !viewmodel.shouldShowAddButton
    }
}
