//
//  MainTableViewCell.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    static let id = "GyroCell"
    
    private let measurementTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let measurementType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let measurementValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let measurementPartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let measurementWholeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(measurementWholeStackView)
        
        measurementWholeStackView.addArrangedSubview(measurementPartStackView)
        measurementWholeStackView.addArrangedSubview(measurementValue)
        
        measurementPartStackView.addArrangedSubview(measurementTime)
        measurementPartStackView.addArrangedSubview(measurementType)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            measurementWholeStackView.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                constant: 30
            ),
            measurementWholeStackView.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                constant: -30
            ),
            measurementWholeStackView.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor
            ),
            measurementWholeStackView.bottomAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.bottomAnchor
            ),
            
            measurementPartStackView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: 0.6
            ),
            
            contentView.heightAnchor.constraint(equalToConstant: CGFloat(80))
        ])
    }
    
    func configureLabelText(motion: Motion) {
        measurementTime.text = motion.date
        measurementType.text = motion.measurementType
        measurementValue.text = "\(motion.runtime)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        measurementTime.text = ""
        measurementType.text = ""
        measurementValue.text = ""
    }
}
