//
//  DetailView.swift
//  MyMovies
//
//  Created by link on 1/2/21.
//

import UIKit

class DetailView:UIView {
	enum imageSize {
		static var backHeight:CGFloat = 280.0
		static var posterHeight:CGFloat = 180
		static var posterWigth:CGFloat = 120

	}
	
	var segmentData = [SegmentDetailModel]()
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
		self.isUserInteractionEnabled = true
		segmentData = [
			// FIXME: - add view
			// info
			// trailer
			// Info     Trailer    Actors    Posters
			SegmentDetailModel(name: "Info", view: overviewLabel),
			SegmentDetailModel(name: "Trailer", view: overviewLabel2),
			SegmentDetailModel(name: "Actors", view: overviewLabel2),
			SegmentDetailModel(name: "Posters", view: overviewLabel2)
		]
		
		[
			backgroundPoster,
			mainView,
			bottomViews
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview($0)
		}
		[
			posterImage
			
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			mainView.addSubview($0)
		}
		
//		[
//			titleLabel,
//			origTitleLabel,
//			dateCreateLabel,
//			genresLabel,
//			statusLabel,
//			voteImage,
//			voteAverageLabel,
//			playButton
//			//runtime продолжительность
//
//		].forEach {
//			$0.translatesAutoresizingMaskIntoConstraints = false
//			segmentedControl.addSubview($0)
//		}
		setupLayout()
	}

	// MARK: - main UI obj
	lazy var backgroundPoster: UIImageView = {
		let iv = UIImageView()
		
		iv.backgroundColor = .systemGray
		iv.addSubview(buttonPlayLastTrailer)
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()
	
	lazy var buttonPlayLastTrailer: UIButton = {
		let b = UIButton(type: .custom)
		b.setImage(UIImage(named: "playButton"), for: .normal)
		b.addTarget(self, action: #selector(playLast), for: .touchUpInside)
		b.translatesAutoresizingMaskIntoConstraints = false
		return b
	}()
	
	lazy var mainView: UIView = {
		let mv = UIView()
		mv.backgroundColor = ColorMode.background
		mv.layer.shadowColor = UIColor.black.cgColor
		
		mv.layer.shadowRadius = 4
		mv.layer.shadowOpacity = 0.5
		mv.layer.shadowOffset = CGSize(width: 0, height: 2)
//		mv.layer.shadowColor = UIColor.black.cgColor

		return mv
	}()
	lazy var bottomViews:UIView = {
		let v = UIView()
//		v.layer.borderWidth = 2
//		v.layer.borderColor = UIColor.black.cgColor
	
		[
			segmentedControl,
			segmentView
			
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			v.addSubview($0)
		}

		return v
	}()
	lazy var segmentView:UIView = {
		let v = UIView()

		
//		UISegmentedControl(items: <#T##[Any]?#>)
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
	lazy var posterImage: UIImageView = {
		let i = UIImage(named: "ImageNotFound")
		let iv = UIImageView(image: i)
		return iv
	}()
	@objc func playLast() {
		print("play last")
	}

	
	//
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
		let sc = UISegmentedControl(items: segmentData.map { $0.name })
		sc.selectedSegmentIndex = 0
		sc.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
		return sc
	}()
	@objc func valueChanged(_ selector:UISegmentedControl) {
		segmentView.bringSubviewToFront(segmentData[selector.selectedSegmentIndex].view)
	}
	// MARK: - Constraints
	func setupLayout() {
		let array = [
			backgroundPoster.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			backgroundPoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			backgroundPoster.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			backgroundPoster.heightAnchor.constraint(equalToConstant: imageSize.backHeight),
			
			buttonPlayLastTrailer.topAnchor.constraint(equalTo: backgroundPoster.topAnchor, constant: Space.quadruple),
			buttonPlayLastTrailer.centerXAnchor.constraint(equalTo: backgroundPoster.centerXAnchor),
			
			mainView.topAnchor.constraint(equalTo: backgroundPoster.bottomAnchor),
			mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

			posterImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: -imageSize.posterHeight*0.4),
			posterImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Space.triple),
			posterImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -Space.single),
			// size
			posterImage.widthAnchor.constraint(equalToConstant: imageSize.posterWigth),
			posterImage.heightAnchor.constraint(equalToConstant: imageSize.posterHeight),
			
			

//
			bottomViews.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: Space.half),
			bottomViews.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Space.single),
			bottomViews.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Space.single),
			
			segmentedControl.topAnchor.constraint(equalTo: bottomViews.topAnchor, constant: Space.single),
			segmentedControl.leadingAnchor.constraint(equalTo: bottomViews.leadingAnchor),
			segmentedControl.trailingAnchor.constraint(equalTo: bottomViews.trailingAnchor),
			
			segmentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Space.single),
			segmentView.leadingAnchor.constraint(equalTo: bottomViews.leadingAnchor, constant: Space.single),
			segmentView.trailingAnchor.constraint(equalTo: bottomViews.trailingAnchor, constant: -Space.single),
			segmentView.bottomAnchor.constraint(equalTo: bottomViews.bottomAnchor, constant: -Space.single),
//
//			titleLabel.topAnchor.constraint(equalTo: gradientBackground.topAnchor, constant: Space.quadruple),
//			titleLabel.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: Space.double),
//			titleLabel.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -Space.double),
//
//			origTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Space.single),
//			origTitleLabel.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: Space.double),
//			origTitleLabel.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -Space.double),
//
//			dateCreateLabel.topAnchor.constraint(equalTo: origTitleLabel.bottomAnchor, constant: Space.single),
//			dateCreateLabel.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: Space.double),
//
//			statusLabel.topAnchor.constraint(equalTo: dateCreateLabel.topAnchor),
//			statusLabel.leadingAnchor.constraint(equalTo: dateCreateLabel.trailingAnchor,constant: Space.single),
//			statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientBackground.trailingAnchor),
//
//			genresLabel.topAnchor.constraint(equalTo: dateCreateLabel.bottomAnchor, constant: Space.single),
//			genresLabel.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor,constant: Space.double),
//			genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientBackground.trailingAnchor),
//
//			voteImage.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: Space.single),
//			voteImage.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: Space.double),
//			voteImage.bottomAnchor.constraint(lessThanOrEqualTo: gradientBackground.bottomAnchor),
//			voteImage.widthAnchor.constraint(equalTo: voteImage.heightAnchor),
////			voteImage.heightAnchor.constraint(equalToConstant: 20),
//
//			voteAverageLabel.topAnchor.constraint(equalTo: voteImage.topAnchor),
//			voteAverageLabel.leadingAnchor.constraint(equalTo: voteImage.trailingAnchor,constant: Space.half),
//			voteAverageLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientBackground.trailingAnchor),
//
//			playButton.topAnchor.constraint(equalTo: voteAverageLabel.topAnchor),
//			playButton.leadingAnchor.constraint(equalTo: voteAverageLabel.trailingAnchor, constant: Space.single)
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

extension DetailView: MovieDetailViewDelegateInput {
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

struct SegmentDetailModel {
	var name: String
	var view: UIView
}
