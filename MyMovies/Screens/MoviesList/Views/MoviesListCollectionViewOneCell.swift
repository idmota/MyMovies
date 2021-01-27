//
//  MoviesListCollectionViewOneCell.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit

class MoviesListCollectionViewOneCell: UICollectionViewCell {
	let circleRatingSize:CGFloat = 36
	enum imageLogoSize {
		static let width:CGFloat = 120  // 154
		static let height:CGFloat = 180 // 231
		
	}
	weak var delegate: MoviesListProtocol?
	private let imageCache = MyCache.sharedInstance

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = UIColor(named: "mainBackground")
		
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		vGradientLayer.frame = circleView.bounds
		CATransaction.commit()
	}
	
	private var imageURL: URL? {
		didSet {
			self.downloadItemImageForSearchResult(imageURL: imageURL)
		}
	}
	
	private func setupView() {
		contentView.addSubview(mainView)
		
		[
			customContentView,
			posterImage,
			circleView,
			ratinglabel
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			mainView.addSubview($0)
		}
		
		[
			activityIndicator
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			posterImage.addSubview($0)
		}
		[
			titlelabel,
			genreslabel,
			dutationLabel,
			seporatorLineView,
			overView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			customContentView.addSubview($0)
		}
		
		setupLayout()
	}
	// MARK: - first level
	private lazy var mainView:UIView = {
		let v = UIView()
		v.backgroundColor = UIColor(named: "mainBackground")
		
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	private lazy var customContentView:UIView = {
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
	private lazy var posterImage:UIImageView = {
		let v = UIImageView()
		v.image = UIImage(named: "ImageNotFound")
		v.backgroundColor = .lightGray
		v.addSubview(activityIndicator)
		
		v.layer.cornerRadius = 5
		v.layer.shadowColor = ColorMode.titleColor.cgColor
		v.layer.shadowOpacity = 0.4
		v.layer.shadowOffset = CGSize(width: 2, height: 2)
		v.layer.shadowRadius = 4
		v.layer.shadowPath = UIBezierPath(roundedRect:v.bounds, cornerRadius: 5).cgPath
		v.clipsToBounds = true
		v.contentMode = .scaleAspectFit
		return v
	}()
	private lazy var circleView: UIView = {
		let v = UIView()
		
		v.backgroundColor = ColorMode.color1
		v.layer.cornerRadius = circleRatingSize/2
		v.clipsToBounds = true
		v.layer.insertSublayer(vGradientLayer, at: 2)
		
		return v
	}()
	// MARK: - second level
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let g = UIActivityIndicatorView(style: .large)
		g.translatesAutoresizingMaskIntoConstraints = false
		return g
	}()
	private lazy var vGradientLayer: CAGradientLayer = {
		let gradient = CAGradientLayer()
		let l1 = ColorMode.color1.withAlphaComponent(1)
		let l2 = ColorMode.color2.withAlphaComponent(1)
		
		gradient.colors = [l1.cgColor,l2.cgColor]
		gradient.startPoint = CGPoint(x:  0.25, y: 0)
		gradient.endPoint = CGPoint(x: 0.75, y: 0.9)
		
		return gradient
	}()
	
	private lazy var titlelabel:UILabel = {
		let v = UILabel()
		v.numberOfLines = 1
		v.font = UIFont.systemFont(ofSize: 15, weight: .bold)
		v.backgroundColor = ColorMode.background
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	private lazy var genreslabel:UILabel = {
		let v = UILabel()
		v.font = UIFont.systemFont(ofSize: 9)
		v.textColor = .gray
		v.numberOfLines = 0
		v.backgroundColor = ColorMode.background
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	private lazy var dutationLabel:UILabel = {
		let v = UILabel()
		v.font = UIFont.systemFont(ofSize: 9)
		v.numberOfLines = 0
		v.backgroundColor = ColorMode.background
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	private lazy var seporatorLineView:UIView = {
		let s = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 1))
		s.layer.borderColor = UIColor.gray.cgColor
		s.layer.borderWidth = 1
		return s
	}()
	
	private lazy var ratinglabel:UILabel = {
		let v = UILabel()
		v.textColor = .white
		v.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		return v
	}()
	
	private lazy var overView:UILabel = {
		let l = UILabel()
		l.numberOfLines = 0
		l.textColor = .gray
		l.font = UIFont.systemFont(ofSize: 10)
		l.backgroundColor = ColorMode.background
		return l
	}()
	
	// MARK: - layout
	private func setupLayout() {
		let array = [
			mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Space.single),
			mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Space.single),
			mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Space.single),
			mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Space.single),
			
			customContentView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: imageLogoSize.height*0.14),
			customContentView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
			customContentView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
			customContentView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
			
			posterImage.topAnchor.constraint(equalTo: mainView.topAnchor),
			posterImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Space.single),
			posterImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -Space.single),
			posterImage.heightAnchor.constraint(equalToConstant: imageLogoSize.height),
			posterImage.widthAnchor.constraint(equalToConstant: imageLogoSize.width),
			
			circleView.trailingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: circleRatingSize/2),
			circleView.bottomAnchor.constraint(lessThanOrEqualTo: posterImage.bottomAnchor, constant: -Space.single),
			circleView.heightAnchor.constraint(equalToConstant: circleRatingSize),
			circleView.widthAnchor.constraint(equalToConstant: circleRatingSize),
			
			ratinglabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
			ratinglabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
			
			activityIndicator.centerYAnchor.constraint(equalTo: posterImage.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: posterImage.centerXAnchor),
			
			titlelabel.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: Space.single),
			titlelabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.triple),
			titlelabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -Space.single),
			
			genreslabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: Space.half),
			genreslabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.triple),
			genreslabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -Space.single),
			
			dutationLabel.topAnchor.constraint(equalTo: genreslabel.bottomAnchor, constant: Space.half),
			dutationLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.triple),
			dutationLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -Space.single),
			
			seporatorLineView.topAnchor.constraint(equalTo: dutationLabel.bottomAnchor, constant: Space.half),
			seporatorLineView.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.triple),
			seporatorLineView.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -Space.single),
			seporatorLineView.heightAnchor.constraint(equalToConstant: 1),
			
			overView.topAnchor.constraint(equalTo: seporatorLineView.bottomAnchor, constant: Space.single),
			overView.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.triple),
			overView.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -Space.single),
			overView.bottomAnchor.constraint(lessThanOrEqualTo: customContentView.bottomAnchor, constant: -Space.single)
			
		]
		NSLayoutConstraint.activate(array)
	}
	
	
	func downloadItemImageForSearchResult(imageURL: URL?) {
		if let urlOfImage = imageURL {
			if let cachedImage = imageCache.object(forKey: urlOfImage.absoluteString as NSString){
				self.posterImage.image = cachedImage
			} else {
				activityIndicator.startAnimating()
				delegate?.downloadItemImageForSearchResult(imageURL: urlOfImage, completion: { [weak self](result) in
					DispatchQueue.main.async() {
						switch result {
						case .success(let image):
							self?.posterImage.image = image
							self?.activityIndicator.stopAnimating()
							self?.imageCache.setObject(image, forKey: urlOfImage.absoluteString as NSString, cost: 1)
						case .failure(let error):
							self?.activityIndicator.stopAnimating()
							Logger.handleError(error)
						}
					}
				})
			}
		}
		
	}
	override func prepareForReuse() {
		self.activityIndicator.stopAnimating()
	}
	
	deinit {
		self.activityIndicator.stopAnimating()
	}
}
// MARK: - fill cell
extension MoviesListCollectionViewOneCell:MoviesListCellProtocol {
	func fill(model:MovieModel) {
		titlelabel.text = "\(model.title)"
		if let posterPath = model.posterPath {
			imageURL = Url.getPosterURL(path: posterPath)
		} else {
			posterImage.image = UIImage(named: "ImageNotFound")
			
		}
		ratinglabel.text = String(model.voteAverage)
		genreslabel.text = model.genre.compactMap({String($0.name)}).joined(separator: ", ")
		var dutationtext = "\("Movie.ReliseDate.Title".localized): \("System.unknown".localized)"
		if let reliseDate = model.releaseDate, !reliseDate.isEmpty {
			dutationtext = "\("Movie.ReliseDate.Title".localized): \(Date(fromString: reliseDate).toString)"
		}
		dutationLabel.text = dutationtext
		overView.text = model.overview
	}
}
