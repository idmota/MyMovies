//
//  MovieDetailView.swift
//  MyMovies
//
//  Created by link on 12/15/20.
//

import UIKit
import AVKit

//import AVFoundation

class MovieDetailView:UIView {
	var segmentViews = [UIView]()
	weak var delegate: MovieDetailViewDelegateOutput?
	public var imageURL: URL? {
		didSet {
			self.downloadItemImageForSearchResult(imageURL: imageURL)
		}
	}

	init(delegate:MovieDetailViewDelegateOutput) {
		self.delegate = delegate
		super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		backgroundColor = ColorMode.background

		[
			backgroundPoster,
			gradientBackground,
			segmentedControl,
			bottomViews
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview($0)
		}
		[
			titleLabel,
			origTitleLabel,
			dateCreateLabel,
			genresLabel,
			statusLabel,
			voteImage,
			voteAverageLabel,
			playButton
			//runtime продолжительность
			
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			gradientBackground.addSubview($0)
		}
		setupLayout()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = gradientBackground.bounds
	}
	lazy var backgroundPoster: UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = .systemGray
//		iv.contentMode = .scaleAspectFit
//		iv.contentMode = .scaleToFill
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()
	lazy var gradientBackground: UIView = {
		let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
//		v.backgroundColor = .yellow
		v.layer.insertSublayer(gradientLayer, at: 0)
		return v
	}()
	lazy var gradientLayer: CAGradientLayer = {
		let gradient = CAGradientLayer()
//		gradient.frame = v.bounds
		let l1 = ColorMode.background.withAlphaComponent(0)
		let l2 = ColorMode.background.withAlphaComponent(0.3)
		let l3 = ColorMode.background.withAlphaComponent(0.4)
		let l4 = ColorMode.background.withAlphaComponent(0.5)
		let l5 = ColorMode.background.withAlphaComponent(0.6)
		let l6 = ColorMode.background.withAlphaComponent(0.7)
		let l7 = ColorMode.background.withAlphaComponent(0.8)
		let l8 = ColorMode.background.withAlphaComponent(0.9)
		let l9 = ColorMode.background.withAlphaComponent(1)
		let l10 = ColorMode.background.withAlphaComponent(1)

		gradient.colors = [l1.cgColor,l6.cgColor, l7.cgColor, l10.cgColor]
		return gradient
	}()
	lazy var titleLabel: UILabel = {
		let l = UILabel()
		l.numberOfLines = 0
		l.font = UIFont.systemFont(ofSize: 22)

		return l
	}()
	lazy var origTitleLabel: UILabel = {
		let l = UILabel()
		l.textColor = .systemGray
		l.numberOfLines = 0
		l.font = UIFont.systemFont(ofSize: 16)

		return l
	}()
	lazy var dateCreateLabel: UILabel = {
		let l = UILabel()
		l.text = "21 июня"
		return l
	}()
	lazy var statusLabel: UILabel = {
		let l = UILabel()
		return l
	}()
	lazy var voteAverageLabel: UILabel = {
		let l = UILabel()
		return l
	}()
	lazy var genresLabel: UILabel = {
		let l = UILabel()
		l.numberOfLines = 0
		return l
	}()

	lazy var voteImage: UIImageView = {
		let vi = UIImageView()

		vi.image = UIImage(systemName: "star.fill")
		vi.tintColor = .systemGray2
		return vi
	}()
	lazy var bottomViews:UIView = {
		let v = UIView()
		segmentViews = [
			// info
			// trailer
			overviewLabel,
			overviewLabel2
		]
		segmentViews.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			v.addSubview($0)
			
			$0.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
			$0.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
			$0.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
			$0.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
		}
		v.bringSubviewToFront(segmentViews[0])

		return v
	}()
	// FIXME: - add 3 uiview
	lazy var overviewLabel: UILabel = {
		var l = UILabel()
		l.numberOfLines = 0
		l.text = "q"
		l.backgroundColor = ColorMode.background
		return l
	}()
	lazy var overviewLabel2: UILabel = {
		var l = UILabel()
		l.numberOfLines = 0
		l.text = "s\r \n s sadsadsad"
		l.backgroundColor = ColorMode.background
		return l
	}()
	
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
		let sc = UISegmentedControl(items: ["Info","Trailer", "Actors"])
		sc.selectedSegmentIndex = 0
		sc.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
		return sc
	}()
	@objc func valueChanged(_ selector:UISegmentedControl) {
		bottomViews.bringSubviewToFront(segmentViews[selector.selectedSegmentIndex])
	}
	func setupLayout() {
		let array = [
			backgroundPoster.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			backgroundPoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			backgroundPoster.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			backgroundPoster.heightAnchor.constraint(equalToConstant: 300),
			
			gradientBackground.heightAnchor.constraint(equalToConstant: 200),
			gradientBackground.leadingAnchor.constraint(equalTo: backgroundPoster.leadingAnchor),
			gradientBackground.trailingAnchor.constraint(equalTo: backgroundPoster.trailingAnchor),
			gradientBackground.bottomAnchor.constraint(equalTo: backgroundPoster.bottomAnchor),
			
			segmentedControl.topAnchor.constraint(equalTo: backgroundPoster.bottomAnchor, constant: Space.single),
			segmentedControl.leadingAnchor.constraint(equalTo: backgroundPoster.leadingAnchor, constant: Space.single),
			
			bottomViews.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Space.single),
			bottomViews.leadingAnchor.constraint(equalTo: backgroundPoster.leadingAnchor, constant: Space.single),
			bottomViews.trailingAnchor.constraint(equalTo: backgroundPoster.trailingAnchor, constant: -Space.single),

			titleLabel.topAnchor.constraint(equalTo: gradientBackground.topAnchor, constant: Space.quadruple),
			titleLabel.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: Space.double),
			titleLabel.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -Space.double),

			origTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Space.single),
			origTitleLabel.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: Space.double),
			origTitleLabel.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -Space.double),
			
			dateCreateLabel.topAnchor.constraint(equalTo: origTitleLabel.bottomAnchor, constant: Space.single),
			dateCreateLabel.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: Space.double),
				
			statusLabel.topAnchor.constraint(equalTo: dateCreateLabel.topAnchor),
			statusLabel.leadingAnchor.constraint(equalTo: dateCreateLabel.trailingAnchor,constant: Space.single),
			statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientBackground.trailingAnchor),
			
			genresLabel.topAnchor.constraint(equalTo: dateCreateLabel.bottomAnchor, constant: Space.single),
			genresLabel.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor,constant: Space.double),
			genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientBackground.trailingAnchor),

			voteImage.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: Space.single),
			voteImage.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: Space.double),
			voteImage.bottomAnchor.constraint(lessThanOrEqualTo: gradientBackground.bottomAnchor),
			voteImage.widthAnchor.constraint(equalTo: voteImage.heightAnchor),
//			voteImage.heightAnchor.constraint(equalToConstant: 20),

			voteAverageLabel.topAnchor.constraint(equalTo: voteImage.topAnchor),
			voteAverageLabel.leadingAnchor.constraint(equalTo: voteImage.trailingAnchor,constant: Space.half),
			voteAverageLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientBackground.trailingAnchor),
			
			playButton.topAnchor.constraint(equalTo: voteAverageLabel.topAnchor),
			playButton.leadingAnchor.constraint(equalTo: voteAverageLabel.trailingAnchor, constant: Space.single)
		]
		NSLayoutConstraint.activate(array)
	}
	public func downloadItemImageForSearchResult(imageURL: URL?) {
		
		if let urlOfImage = imageURL {
			
			URLSession.shared.downloadTask(
				with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
					DispatchQueue.main.async() {
						if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
							
							let imageToCache = image
							
							if let strongSelf = self{
								
								strongSelf.backgroundPoster.image = imageToCache
							}
						}
					}
					
				}).resume()
			
			
			
			
		}
	}

}

extension MovieDetailView: MovieDetailViewDelegateInput {
	func fillViewFromModel(model:MovieDetailModel) {
		titleLabel.text = model.title
		origTitleLabel.text = model.originalTitle
		
		dateCreateLabel.text = Date(fromString: model.releaseDate).toString //"2020-07-31"
		genresLabel.text = "Genre "+model.genres.compactMap({$0.name}).joined(separator: ", ")
		
		statusLabel.text = "Movie.\(model.status.rawValue)".localized
		voteAverageLabel.text = model.voteAverage.description
		
		imageURL = Url.getBackPosterURL(posterPath:model.backdropPath)
		overviewLabel.text = model.overview
	}
}
