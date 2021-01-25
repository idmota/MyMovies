//
//  DetailView.swift
//  MyMovies
//
//  Created by link on 1/2/21.
//

import UIKit

final class DetailView:UIView {
	enum imageSize {
		static var backHeight:CGFloat = 280.0
		static var posterHeight:CGFloat = 180
		static var posterWigth:CGFloat = 120
		static var posterDelta: CGFloat {
			return posterHeight * 0.4
		}
	}
	
	weak var delegate: MovieDetailViewDelegateOutput?
	
	init(delegate:MovieDetailViewDelegateOutput) {
		self.delegate = delegate
		super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public var backgroundURL: URL? {
		didSet {
			guard let delegatedowloadPictures = delegate?.dowloadPictures else {return}
			
			delegatedowloadPictures(backgroundURL) { [weak self](result) in
				if let image = result, let self = self {
					self.backgroundImage.image = image
				}
			}
		}
	}
	public var posterURL: URL? {
		didSet {
			guard let delegatedowloadPictures = delegate?.dowloadPictures else {return}
			
			delegatedowloadPictures(posterURL) { [weak self](result) in
				if let image = result, let self = self {
					self.posterImage.image = image
				}
			}
		}
	}
	
	private func setupView() {
		backgroundColor = ColorMode.background
		
		[
			backgroundImage,
			playLastTrailerView,
			mainView,
			bottomViews
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview($0)
		}
		[
			posterViewShadow
			
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			mainView.addSubview($0)
		}
		[
			titleLabel,
			origTitleLabel,
			genresLabel,
			dateReliseAndStatusLabel,
			voteImage,
			voteAverageLabel
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			mainView.addSubview($0)
		}
		setupLayout()
	}
	
	private func setupFrame() {
		super.layoutSubviews()
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		gradientLayer.frame = backGradientView.bounds
		CATransaction.commit()
		
	}
	
	// MARK: - main UI obj
	private lazy var backgroundImage: UIImageView = {
		let iv = UIImageView()
		
		iv.backgroundColor = .systemGray
		iv.contentMode = .scaleAspectFill
		iv.isUserInteractionEnabled = false
		iv.clipsToBounds = true
		
		return iv
	}()

	private lazy var playLastTrailerView: UIButton = {
		
		let b = UIButton(type: .custom)
		let i = UIImage(named: "playButton")
		b.setBackgroundImage(i, for: .normal)
		b.addTarget(self, action: #selector(playLast(_:)), for: .touchUpInside)
		b.translatesAutoresizingMaskIntoConstraints = false
		return b
	}()
	
	@objc private func playLast(_ sender: Any) {
		if let sDV = (segmentedView as? DetailSegmentedViewInput) {
			sDV.playLastTrailler()
		}
	}
	
	private lazy var mainView: UIView = {
		let mv = UIView()
		mv.backgroundColor = ColorMode.background
		mv.layer.shadowColor = UIColor.black.cgColor
		mv.layer.shadowRadius = 4
		mv.layer.shadowOpacity = 0.5
		mv.layer.shadowOffset = CGSize(width: 0, height: 2)
		mv.layer.rasterizationScale = UIScreen.main.scale
		mv.layer.shouldRasterize = true
		
		mv.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movieView(_:))))
		
		return mv
	}()
	private lazy var bottomViews:UIView = {
		let v = UIView()
		v.backgroundColor = ColorMode.background
		
		v.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movieView(_:))))
		[
			segmentedView
			
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			v.addSubview($0)
		}
		
		return v
	}()
	private lazy var segmentedView: UIView = {
		let sv = DetailSegmentedView()
		return sv
	}()
	
	private var oldYPos:CGFloat = 0.0
	@objc private func movieView(_ sender: UIPanGestureRecognizer) {
		
		switch sender.state {
		
		case .began:
			oldYPos = self.constr?.constant ?? 0
		case .changed:
			let viewTranslation = sender.translation(in: bottomViews)
			let constSumm = self.oldYPos + viewTranslation.y
			if constSumm < 230 {
				self.constr?.constant = constSumm
				
				UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
					self.layoutIfNeeded()
				})
			}
		case .ended:
			let viewTranslation = sender.translation(in: bottomViews)
			if viewTranslation.y < 0 {
				
				let animationSpace = -self.backgroundImage.frame.height + imageSize.posterDelta + Space.single
				self.constr?.constant = animationSpace
				
			} else {
				self.constr?.constant = 0
				
			}
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.layoutIfNeeded()
			})
		default:
			break
		}
	}
	
	
	
	
	// MARK: - detail UI obj
	private lazy var posterViewShadow:UIView = {
		let v = UIView()
		v.layer.shadowColor = UIColor.black.cgColor
		v.layer.shadowRadius = 4
		v.layer.shadowOpacity = 0.5
		v.layer.shadowOffset = CGSize(width: 0, height: 2)
		v.layer.rasterizationScale = UIScreen.main.scale
		v.layer.shouldRasterize = true
		
		v.translatesAutoresizingMaskIntoConstraints = false
		v.addSubview(posterImage)
		return v
	}()
	private lazy var posterImage: UIImageView = {
		let i = UIImage(named: "ImageNotFound")
		let iv = UIImageView(image: i)
		iv.layer.cornerRadius = 4.56
		iv.clipsToBounds = true
		iv.addSubview(backGradientView)
		return iv
	}()
	private lazy var backGradientView: UIView = {
		let v = UIView()
		
		v.layer.addSublayer(gradientLayer)
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	private lazy var gradientLayer: CAGradientLayer = {
		let gradient = CAGradientLayer()
		let l1 = UIColor.black.withAlphaComponent(0)
		let l2 = UIColor.black.withAlphaComponent(1)
		
		gradient.colors = [l1.cgColor,l2.cgColor]
		gradient.startPoint = CGPoint(x:  0, y: 0)
		gradient.endPoint = CGPoint(x: 0, y: 1)
		gradient.timeOffset = 0
		return gradient
	}()
	
	private lazy var titleLabel: UILabel = {
		let l = UILabel()
		
		l.font = UIFont.systemFont(ofSize: 24)
		l.numberOfLines = 0
		l.textAlignment = .center
		l.textColor = UIColor.white
		
		
		return l
	}()
	private lazy var origTitleLabel: UILabel = {
		let l = UILabel()
		l.textColor = .systemGray
		l.textAlignment = .left
		l.numberOfLines = 0
		l.font = UIFont.systemFont(ofSize: 16)
		
		return l
	}()
	private lazy var genresLabel: UILabel = {
		let l = UILabel()
		l.numberOfLines = 0
		l.font = UIFont.systemFont(ofSize: 12)
		l.textColor = .gray
		
		return l
	}()
	
	private lazy var dateReliseAndStatusLabel: UILabel = {
		let l = UILabel()
		l.font = UIFont.systemFont(ofSize: 12)
		l.textColor = .gray
		
		return l
	}()
	private lazy var statusLabel: UILabel = {
		let l = UILabel()
		return l
	}()
	private lazy var voteAverageLabel: UILabel = {
		let l = UILabel()
		l.textColor = .systemRed
		return l
	}()
	
	
	private lazy var voteImage: UIImageView = {
		let vi = UIImageView()
		
		vi.image = UIImage(systemName: "star.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
		vi.tintColor = .systemGray2
		return vi
	}()
	
	
	// MARK: - Constraints
	private var constr: NSLayoutConstraint?
	private func setupLayout() {
		constr = mainView.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 0)
		constr?.isActive = true
		let array = [
			backgroundImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			backgroundImage.heightAnchor.constraint(equalToConstant: imageSize.backHeight),
			
			playLastTrailerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 100),
			playLastTrailerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			
			posterViewShadow.topAnchor.constraint(equalTo: mainView.topAnchor, constant: -imageSize.posterDelta),
			posterViewShadow.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Space.triple),
			posterViewShadow.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -Space.single),
			
			posterViewShadow.widthAnchor.constraint(equalToConstant: imageSize.posterWigth),
			posterViewShadow.heightAnchor.constraint(equalToConstant: imageSize.posterHeight),
			
			posterImage.topAnchor.constraint(equalTo: posterViewShadow.topAnchor),
			posterImage.leadingAnchor.constraint(equalTo: posterViewShadow.leadingAnchor),
			posterImage.trailingAnchor.constraint(equalTo: posterViewShadow.trailingAnchor),
			posterImage.bottomAnchor.constraint(equalTo: posterViewShadow.bottomAnchor),
			
			backGradientView.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor),
			backGradientView.trailingAnchor.constraint(equalTo: posterImage.trailingAnchor),
			backGradientView.bottomAnchor.constraint(equalTo: posterImage.bottomAnchor),
			backGradientView.heightAnchor.constraint(equalToConstant: 50),
			
			bottomViews.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: Space.half),
			bottomViews.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			bottomViews.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			bottomViews.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
			
			segmentedView.topAnchor.constraint(equalTo: bottomViews.topAnchor),
			segmentedView.leadingAnchor.constraint(equalTo: bottomViews.leadingAnchor),
			segmentedView.trailingAnchor.constraint(equalTo: bottomViews.trailingAnchor),
			segmentedView.bottomAnchor.constraint(equalTo: bottomViews.bottomAnchor),
			
			titleLabel.topAnchor.constraint(greaterThanOrEqualTo: posterImage.topAnchor, constant: -Space.quadruple),
			titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.single),
			titleLabel.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -Space.single),
			titleLabel.bottomAnchor.constraint(equalTo: mainView.topAnchor, constant: -Space.single),
			
			origTitleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: Space.single),
			origTitleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.single),
			origTitleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Space.single),
			
			genresLabel.topAnchor.constraint(equalTo: origTitleLabel.bottomAnchor),
			genresLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.single),
			genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: mainView.trailingAnchor, constant: -Space.single),
			
			dateReliseAndStatusLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor),
			dateReliseAndStatusLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.single),
			dateReliseAndStatusLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Space.single),
			
			voteImage.topAnchor.constraint(equalTo: dateReliseAndStatusLabel.bottomAnchor),
			voteImage.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.single),
			voteImage.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor),
			voteImage.widthAnchor.constraint(equalToConstant: 20),
			voteImage.heightAnchor.constraint(equalToConstant: 20),
			voteImage.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor, constant: -Space.single),
			
			voteAverageLabel.topAnchor.constraint(equalTo: voteImage.topAnchor),
			voteAverageLabel.leadingAnchor.constraint(equalTo: voteImage.trailingAnchor, constant: Space.half),
			voteAverageLabel.trailingAnchor.constraint(lessThanOrEqualTo: mainView.trailingAnchor, constant: -Space.single),
			voteAverageLabel.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor, constant: -Space.single)
		]
		
		NSLayoutConstraint.activate(array)
	}
	
}

extension DetailView: MovieDetailViewDelegateInput {
	
	func fillViewFromModel(model:MovieDetailModel) {

		let reliseLoc = "Movie.\(model.status.rawValue)".localized
		dateReliseAndStatusLabel.text = "\(Date(fromString: model.releaseDate).toString), \(reliseLoc)"
		genresLabel.text = model.genres.compactMap({$0.name}).joined(separator: ", ")
		
		if let segmentedViewInput = segmentedView as? DetailSegmentedViewInput {
			segmentedViewInput.fillSegmentViewFromModel(model: model)
		}
	}
	func fillViewFromModel(_ model:MovieModel) {
		titleLabel.text = model.title
		origTitleLabel.text = model.originalTitle
		voteAverageLabel.text = model.voteAverage.description
		
		if let posterPath = model.posterPath {
			posterURL = Url.getPosterURLWithSize(path: posterPath, size: .w185)
		}
		if let backdropPath = model.backdropPath {
			backgroundURL = Url.getBackPosterURL(path:backdropPath)
		}
		setupFrame()

	}
}

