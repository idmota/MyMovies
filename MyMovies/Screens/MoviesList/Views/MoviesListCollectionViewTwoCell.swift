//
//  MoviesListCollectionViewTwoCell.swift
//  MyMovies
//
//  Created by link on 1/13/21.
//

import UIKit
protocol MoviesListCellProtocol {
	func fill(model:MovieModel)
}
class MoviesListCollectionViewTwoCell: UICollectionViewCell {
	let circleRatingSize:CGFloat = 36
	enum imageLogoSize {
		static let width:CGFloat = 120  // 154
		static let height:CGFloat = 180 // 231
		
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		titleGradientLayer.frame = titleView.bounds
		vGradientLayer.frame = circleView.bounds
		
		CATransaction.commit()
	}
	
	private var imageURL: URL? {
		didSet {
			self.downloadItemImageForSearchResult(imageURL: imageURL)
		}
	}
	private func setupView() {
		contentView.backgroundColor = ColorMode.background
		contentView.addSubview(mainView)
		[
			imageView,
			circleView,
			titleView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			mainView.addSubview($0)
		}
		setupLayout()
	}
	
	private lazy var mainView:UIView = {
		let v = UIView()
		
		v.backgroundColor = ColorMode.background
		v.layer.cornerRadius = 5
		
		v.layer.shadowColor = ColorMode.titleColor.cgColor
		v.layer.shadowOpacity = 0.1
		v.layer.shadowOffset = CGSize(width: 0, height: 0)
		v.layer.shadowRadius = 4
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	private lazy var imageView: UIImageView = {
		let imgV = UIImageView()
		imgV.image = UIImage(named: "ImageNotFound")
		imgV.backgroundColor = .lightGray
		imgV.addSubview(activityIndicator)
		
		imgV.layer.cornerRadius = 5
		imgV.layer.shadowColor = ColorMode.titleColor.cgColor
		imgV.layer.shadowOpacity = 0.4
		imgV.layer.shadowOffset = CGSize(width: 2, height: 2)
		imgV.layer.shadowRadius = 4
		imgV.layer.shadowPath = UIBezierPath(roundedRect:imgV.bounds, cornerRadius: 5).cgPath
		imgV.clipsToBounds = true
		imgV.contentMode = .scaleAspectFill
		return imgV
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let g = UIActivityIndicatorView(style: .large)
		g.translatesAutoresizingMaskIntoConstraints = false
		return g
	}()
	private lazy var circleView: UIView = {
		let v = UIView()
		v.layer.cornerRadius = circleRatingSize/2
		v.clipsToBounds = true
		v.layer.insertSublayer(vGradientLayer, at: 1)
		v.addSubview(ratinglabel)
		return v
	}()
	private lazy var ratinglabel:UILabel = {
		let v = UILabel()
		v.textColor = .white
		v.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	// MARK: - second level
	private lazy var vGradientLayer: CAGradientLayer = {
		let gradient = CAGradientLayer()
		let l1 = ColorMode.color1.withAlphaComponent(1)
		let l2 = ColorMode.color2.withAlphaComponent(1)
		
		gradient.colors = [l1.cgColor,l2.cgColor]
		gradient.startPoint = CGPoint(x:  0.25, y: 0)
		gradient.endPoint = CGPoint(x: 0.75, y: 0.9)
		
		return gradient
	}()
	private lazy var titleGradientLayer: CAGradientLayer = {
		let gradient = CAGradientLayer()
		let l1 = ColorMode.titleColor.withAlphaComponent(0)
		let l2 = ColorMode.titleColor.withAlphaComponent(1)
		
		gradient.colors = [l1.cgColor,l2.cgColor]
		gradient.startPoint = CGPoint(x:  0.5, y: 0)
		
		gradient.endPoint = CGPoint(x: 0.5, y: 1)
		
		return gradient
	}()
	
	private lazy var titleView:UIView = {
		let v = UIView()
		v.layer.insertSublayer(titleGradientLayer, at: 3)
		
		[
			yearLabel,
			titleLabel
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			v.addSubview($0)
		}
		v.clipsToBounds = true
		v.layer.cornerRadius = 5
		v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
		return v
	}()
	private lazy var titleLabel: UILabel = {
		let l = UILabel()
		l.font = UIFont.systemFont(ofSize: 15, weight: .bold)
		l.numberOfLines = 0
		l.textColor = ColorMode.background
		return l
	}()
	private lazy var yearLabel: UILabel = {
		let l = UILabel()
		l.font = UIFont.systemFont(ofSize: 15, weight: .bold)
		l.textColor = ColorMode.background
		return l
	}()
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func downloadItemImageForSearchResult(imageURL: URL?) {
		
		if let urlOfImage = imageURL {
			if let cachedImage = imageCache.object(forKey: urlOfImage.absoluteString as NSString){
				self.imageView.image = cachedImage
			} else {
				let session = URLSession.shared
				activityIndicator.startAnimating()
				self.downloadTask = session.downloadTask(
					with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
						DispatchQueue.main.async() {
							if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
								
								let imageToCache = image
								
								if let strongSelf = self{
									
									strongSelf.imageView.image = imageToCache
									
									strongSelf.imageCache.setObject(imageToCache, forKey: urlOfImage.absoluteString as NSString, cost: 1)
									strongSelf.activityIndicator.stopAnimating()
								}
								
								
							} else {
								if let strongSelf = self{
									strongSelf.activityIndicator.stopAnimating()
								}
							}}
					})
				self.downloadTask!.resume()
			}
		}
	}
	private var downloadTask: URLSessionDownloadTask?
	
	let imageCache = MyCache.sharedInstance
	
	
	
	override func prepareForReuse() {
		
		self.downloadTask?.cancel()
		self.activityIndicator.stopAnimating()
		imageView.image = nil
	}
	
	deinit {
		self.downloadTask?.cancel()
		self.activityIndicator.stopAnimating()
		imageView.image = nil
	}
	private func setupLayout() {
		let arrayConstraints = [
			mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Space.half),
			mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Space.single),
			mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Space.single),
			mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Space.half),
			
			imageView.topAnchor.constraint(equalTo: mainView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
			
			activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
			
			circleView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: Space.single),
			circleView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Space.single),
			circleView.heightAnchor.constraint(equalToConstant: circleRatingSize),
			circleView.widthAnchor.constraint(equalToConstant: circleRatingSize),
			
			ratinglabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
			ratinglabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
			
			titleView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
			titleView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
			titleView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
			
			yearLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: Space.double),
			yearLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Space.half),
			yearLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Space.half),
			
			titleLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: Space.half),
			titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: Space.half),
			titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -Space.half),
			titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -Space.single)
		]
		NSLayoutConstraint.activate(arrayConstraints)
	}
}

// MARK: - fill cell
extension MoviesListCollectionViewTwoCell:MoviesListCellProtocol {
	func fill(model:MovieModel) {
		titleLabel.text = "\(model.title)"
		if let posterPath = model.posterPath {
			imageURL = Url.getPosterURL(path: posterPath)
		} else {
			imageView.image = UIImage(named: "ImageNotFound")
			
		}
		ratinglabel.text = String(model.voteAverage)
		if let reliseDate = model.releaseDate, !reliseDate.isEmpty {
			yearLabel.text = Date(fromString: reliseDate).toYearString
		}
	}
}
