//
//  DetailView.swift
//  MyMovies
//
//  Created by link on 1/2/21.
//

import UIKit
//import Foundation
import youtube_ios_player_helper

class DetailView:UIView, YTPlayerViewDelegate {
	enum imageSize {
		static var backHeight:CGFloat = 280.0
		static var posterHeight:CGFloat = 180
		static var posterWigth:CGFloat = 120
		static var posterDelta: CGFloat {
			return posterHeight * 0.4
		}
		
	}
	
	var segmentData = [SegmentDetailModel]()
	weak var delegate: MovieDetailViewDelegateOutput?
	var lastVideoId: String?
	
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
	
	func setupView() {
		backgroundColor = ColorMode.background
		
		segmentData = [
			// FIXME: - add view
			// info
			// trailer
			// Info     Trailer    Actors    Posters
			SegmentDetailModel(name: "Info", view: infoView),
			SegmentDetailModel(name: "Trailer", view: trailerScrollView),//trailerScrollView),
			SegmentDetailModel(name: "Actors", view: infoView),
			SegmentDetailModel(name: "Posters", view: infoView)
		]
		
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
			//runtime продолжительность
			voteImage,
			voteAverageLabel
			//
			//			statusLabel,
			
			//			playButton
			
			
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
	lazy var backgroundImage: UIImageView = {
		let iv = UIImageView()
		
		iv.backgroundColor = .systemGray
		iv.contentMode = .scaleAspectFill
		iv.isUserInteractionEnabled = false
		iv.clipsToBounds = true

		return iv
	}()
	// MARK: - fix
	lazy var playLastTrailerView: UIButton = {
		
		let b = UIButton(type: .custom)
		let i = UIImage(named: "playButton")
//		i?.accessibilityRespondsToUserInteraction = true
		b.setBackgroundImage(i, for: .normal)
		b.addTarget(self, action: #selector(playLast(_:)), for: .touchUpInside)

//		b.setTitle("sss", for: .normal)
		b.translatesAutoresizingMaskIntoConstraints = false
		return b
	}()
//	let lastVP:YTPlayerView = YTPlayerView()
	
	@objc func playLast(_ sender: Any) {
		if let vp = stackView.subviews.last as? YTPlayerView {
			vp.playVideo()
		}
		
		
//		stackView.addArrangedSubview(lastVP)
////		var yp = YTPlayerView()
//		lastVP.delegate = self
//
//		lastVP.load(withVideoId: lastVideoId!)
//
////			yp.clipsToBounds = true
////		yp.widthAnchor.constraint(equalToConstant: widthSizeVideo).isActive = true
////		yp.heightAnchor.constraint(equalToConstant: widthSizeVideo*0.5).isActive = true
//
//
//		lastVP.playVideo()
////			yp.translatesAutoresizingMaskIntoConstraints = false
////			yp.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
////			yp.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
////			yp.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
////			yp.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
//
//
	}
	
	lazy var mainView: UIView = {
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
	lazy var bottomViews:UIView = {
		let v = UIView()
		v.backgroundColor = ColorMode.background

		v.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movieView(_:))))
		[
			segmentedControl,
			segmentView
			
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			v.addSubview($0)
		}
		
		return v
	}()
	
	var oldYPos:CGFloat = 0.0
	@objc func movieView(_ sender: UIPanGestureRecognizer) {
		
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
	
	
	
	lazy var segmentView:UIView = {
		let v = UIView()

		segmentData.forEach {
			$0.view.translatesAutoresizingMaskIntoConstraints = false
			v.addSubview($0.view)
			
			$0.view.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
			$0.view.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
			$0.view.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
			$0.view.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
		}
		v.bringSubviewToFront(segmentData[0].view)
		
		return v
	}()
	
	// MARK: - detail UI obj
	lazy var posterViewShadow:UIView = {
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
	lazy var posterImage: UIImageView = {
		let i = UIImage(named: "ImageNotFound")
		let iv = UIImageView(image: i)
		iv.layer.cornerRadius = 4.56
		iv.clipsToBounds = true
		iv.addSubview(backGradientView)
		return iv
	}()
	lazy var backGradientView: UIView = {
		let v = UIView()
		
		v.layer.addSublayer(gradientLayer)
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	lazy var gradientLayer: CAGradientLayer = {
		let gradient = CAGradientLayer()
		let l1 = UIColor.black.withAlphaComponent(0)
		let l2 = UIColor.black.withAlphaComponent(1)
		
		gradient.colors = [l1.cgColor,l2.cgColor]
		gradient.startPoint = CGPoint(x:  0, y: 0)
		gradient.endPoint = CGPoint(x: 0, y: 1)
		gradient.timeOffset = 0
		return gradient
	}()
	

	
	
	//
	lazy var titleLabel: UILabel = {
		let l = UILabel()
		
		l.font = UIFont.systemFont(ofSize: 24)
		l.numberOfLines = 0
		l.textAlignment = .center
		l.textColor = UIColor.white
		
		
		return l
	}()
	lazy var origTitleLabel: UILabel = {
		let l = UILabel()
		l.textColor = .systemGray
		l.textAlignment = .left
		l.numberOfLines = 0
		l.font = UIFont.systemFont(ofSize: 16)
		
		return l
	}()
	lazy var genresLabel: UILabel = {
		let l = UILabel()
		l.numberOfLines = 0
		l.font = UIFont.systemFont(ofSize: 12)
		l.textColor = .gray
		
		return l
	}()
	
	lazy var dateReliseAndStatusLabel: UILabel = {
		let l = UILabel()
		l.font = UIFont.systemFont(ofSize: 12)
		l.textColor = .gray
		
		return l
	}()
	lazy var statusLabel: UILabel = {
		let l = UILabel()
		return l
	}()
	lazy var voteAverageLabel: UILabel = {
		let l = UILabel()
		l.textColor = .systemRed
		return l
	}()
	
	
	lazy var voteImage: UIImageView = {
		let vi = UIImageView()
		
		vi.image = UIImage(systemName: "star.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
		vi.tintColor = .systemGray2
		return vi
	}()
	
	lazy var infoView:UIView = {
		let iv = UIView()
		iv.backgroundColor = ColorMode.background
		iv.addSubview(overviewLabel)
		
		overviewLabel.translatesAutoresizingMaskIntoConstraints = false
		overviewLabel.topAnchor.constraint(equalTo: iv.topAnchor).isActive = true
		overviewLabel.leadingAnchor.constraint(equalTo: iv.leadingAnchor).isActive = true
		overviewLabel.trailingAnchor.constraint(equalTo: iv.trailingAnchor).isActive = true
		overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: iv.bottomAnchor).isActive = true

		return iv
	}()

	lazy var overviewLabel: UILabel = {
		var l = UILabel()
		l.numberOfLines = 0
		l.text = "q"
//		l.backgroundColor = .red//ColorMode.background
		return l
	}()
	lazy var trailerScrollView: UIScrollView = {
		var l = UIScrollView()
		l.backgroundColor = .white
		stackView.translatesAutoresizingMaskIntoConstraints = false
		l.addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: l.topAnchor).isActive = true
		stackView.leadingAnchor.constraint(equalTo: l.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: l.trailingAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: l.bottomAnchor).isActive = true
		return l
	}()
	
	lazy var stackView: UIStackView = {
		let sv = UIStackView()
//		sv.backgroundColor = .gray
		sv.axis = .vertical
		sv.distribution = .fillProportionally
		sv.alignment = .center
		sv.spacing = Space.single
		return sv
	}()
	// MARK: -- fix
	private func addVideoView(_ videoModel:[VideoModel], widthSizeVideo:CGFloat) {
		videoModel.forEach {
			lastVideoId = $0.key
			var yp = YTPlayerView()
//			yp.delegate = self

			yp.load(withVideoId: $0.key)
			
	//			yp.clipsToBounds = true
			yp.widthAnchor.constraint(equalToConstant: widthSizeVideo).isActive = true
			yp.heightAnchor.constraint(equalToConstant: widthSizeVideo*0.5).isActive = true

			stackView.addArrangedSubview(yp)
//			yp.translatesAutoresizingMaskIntoConstraints = false
//			yp.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
//			yp.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
//			yp.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
//			yp.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true

		}
		
	}
	
	lazy var playButton: UIButton = {
		let b = UIButton()
		b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playVideo)))
		b.setTitle("play video", for: .normal)
		b.setTitleColor(.brown, for: .normal)
		return b
	}()
	
	@objc func playVideo() {
		guard let delegateOpenLink = delegate?.openLink else {return}
		delegateOpenLink()
	}
	lazy var segmentedControl:UISegmentedControl = {
		let sc = UISegmentedControl(items: segmentData.map { $0.name })
		sc.selectedSegmentIndex = 0
		sc.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
		return sc
	}()
	@objc func valueChanged(_ selector:UISegmentedControl) {
		segmentView.bringSubviewToFront(segmentData[selector.selectedSegmentIndex].view)
	}
	// MARK: - Constraints
	var constr: NSLayoutConstraint?
	func setupLayout() {
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
			posterViewShadow.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -Space.single),//greaterThanOrEqualTo lessThanOrEqualTo
			// size
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
			
			
			
			//lessThanOrEqualTo
			bottomViews.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: Space.half),
			bottomViews.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			bottomViews.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			bottomViews.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
			
			segmentedControl.topAnchor.constraint(equalTo: bottomViews.topAnchor, constant: Space.single),
			segmentedControl.leadingAnchor.constraint(equalTo: bottomViews.leadingAnchor),
			segmentedControl.trailingAnchor.constraint(equalTo: bottomViews.trailingAnchor),
			
			segmentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Space.single),
			segmentView.leadingAnchor.constraint(equalTo: bottomViews.leadingAnchor, constant: Space.single),
			segmentView.trailingAnchor.constraint(equalTo: bottomViews.trailingAnchor, constant: -Space.single),
			segmentView.bottomAnchor.constraint(equalTo: bottomViews.bottomAnchor, constant: -Space.single),
			
			// equalTo lessThanOrEqualTo greaterThanOrEqualTo
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
			
			
			
			//
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
	
	//	func setNewLayout() {
	//
	//	}
	// FIXME: - move to another module.
	//
	// bad API, have to send a second request
	
	
}

extension DetailView: MovieDetailViewDelegateInput {
	
	func fillViewFromModel(model:MovieDetailModel) {
		setupFrame()
		titleLabel.text = model.title
		origTitleLabel.text = model.originalTitle
		let reliseLoc = "Movie.\(model.status.rawValue)".localized
		dateReliseAndStatusLabel.text = "\(Date(fromString: model.releaseDate).toString), \(reliseLoc)" //"2020-07-31"
		genresLabel.text = model.genres.compactMap({$0.name}).joined(separator: ", ")
	
		voteAverageLabel.text = model.voteAverage.description
		backgroundURL = Url.getBackPosterURL(path:model.backdropPath)
		if let posterPath = model.posterPath {
			posterURL = Url.getPosterURLWithSize(path: posterPath, size: .w185)
		}
		addVideoView(model.videos.results, widthSizeVideo: trailerScrollView.frame.size.width)
		overviewLabel.text = model.overview
	}
}

struct SegmentDetailModel {
	var name: String
	var view: UIView
}
