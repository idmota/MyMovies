//
//  WalkthroughCollectionViewCell.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//
import UIKit

final class WalkthroughCollectionViewCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
		
	}
	
	private lazy var bgImage:UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = ColorMode.background
		iv.contentMode = .scaleAspectFill
		return iv
	}()
	private lazy var gradientLayer: CAGradientLayer = {
		let gL = CAGradientLayer()
		
		return gL
	}()
	
	private lazy var gradientView: UIView = {
		let v = UIView()
		return v
	}()
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	func make(model:WalkthroughModel) {
		contentView.backgroundColor = model.bGColor
		
		bgImage.image = model.bgImage
		textLabel.text = model.title
		textSubLabel.text = model.subTitle
		
		gradientLayer.startPoint = model.gradient.startPoint
		gradientLayer.endPoint = model.gradient.endPoint
		gradientLayer.frame = self.bounds
		gradientLayer.colors?.removeAll()
		gradientLayer.colors =  model.gradient.colors.map({ $0.cgColor })
		gradientLayer.locations = model.gradient.location
		
		gradientView.layer.sublayers?.removeAll(where: {$0 is CAGradientLayer})
		gradientView.layer.insertSublayer(gradientLayer, at: 1)
		
		
	}
	private lazy var textLabel: UILabel = {
		let l = UILabel()
		l.font = UIFont.systemFont(ofSize: 30, weight: .bold)
		l.textColor = .white
		return l
	}()
	private lazy var textSubLabel: UILabel = {
		let l = UILabel()
		l.font = UIFont.systemFont(ofSize: 30)
		l.textColor = .white
		l.numberOfLines = 0
		return l
	}()
	
	private func setupView() {
		[
			
			bgImage,
			gradientView,
			textLabel,
			textSubLabel
			
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview($0)
		}
		setLayout()
	}
	private func setLayout() {
		let array = [
			bgImage.topAnchor.constraint(equalTo: contentView.topAnchor),
			bgImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			bgImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			bgImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
			
			gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
			gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			
			
			textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: Space.quadruple+Space.double),
			textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			
			textSubLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Space.single),
			textSubLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			
		]
		NSLayoutConstraint.activate(array)
	}
}
