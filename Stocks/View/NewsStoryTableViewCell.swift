//
//  NewsStoryUitTableViewCell.swift
//  Stocks
//
//  Created by jonas silva on 05/07/2021.
//

import UIKit
import SDWebImage

class NewsStoryTableViewCell: UITableViewCell {

static let identifier = "NewsStoryTableViewCell"
    
    static let preferredHeight: CGFloat = 140

    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageUrl: URL?
        
        init(model: NewsStory) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = .string(from: model.datetime)
            self.imageUrl = URL(string: model.image)
        }
    }
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let storyImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        addSubviews(sourceLabel, headlineLabel, dateLabel, storyImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height/1.2
        storyImageView.frame = CGRect(
            x: contentView.width-imageSize-10,
            y: (contentView.height-imageSize) / 2,
            width: imageSize,
            height: imageSize)
        
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imageSize - 15
        
        dateLabel.frame = CGRect(
            x: separatorInset.left,
            y: contentView.height-40,
            width: availableWidth,
            height: 40)
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(
            x: separatorInset.left,
            y: 4,
            width: availableWidth,
            height: sourceLabel.height)
        
        headlineLabel.frame = CGRect(
            x: separatorInset.left,
            y: sourceLabel.bottom + 5 ,
            width: availableWidth,
            height: contentView.height - sourceLabel.bottom - dateLabel.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headlineLabel.text = nil
        sourceLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    public func configure(with viewModel: ViewModel) {
        headlineLabel.text = viewModel.headline
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.dateString
        //IMAGE
        storyImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        //storyImageView.setImage(with: viewModel.imageUrl)
    }
}
