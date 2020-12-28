//
//  MoviesListTableViewCell.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit

class MoviesListTableViewCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		contentView.addSubview(mainView)
		
		[
			posterImage,
			ratinglabel,
			ratingIcon,
			titlelabel
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			mainView.addSubview($0)
		}
		
		setupLayout()
	}
	lazy var mainView:UIView = {
		let v = UIView()
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	lazy var posterImage:UIImageView = {
		let v = UIImageView()
		v.backgroundColor = .darkGray
		v.addSubview(activityIndicator)
		v.layer.cornerRadius = 5
		v.clipsToBounds = true

		return v
	}()
	lazy var activityIndicator: UIActivityIndicatorView = {
		let g = UIActivityIndicatorView(style: .large)
		g.translatesAutoresizingMaskIntoConstraints = false
		return g
	}()
	
	lazy var titlelabel:UILabel = {
		let v = UILabel()
		v.numberOfLines = 0
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	lazy var ratingIcon: UIImageView = {
		let i = UIImageView()
		i.image = UIImage(systemName: "star.fill")
		i.tintColor = .systemGray2
		return i
	}()
	
	lazy var ratinglabel:UILabel = {
		let v = UILabel()
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	public var imageURL: URL? {
		didSet {
			self.downloadItemImageForSearchResult(imageURL: imageURL)
		}
	}
	private var downloadTask: URLSessionDownloadTask?
	
	private func setupLayout() {
		let array = [
			mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Space.single),
			mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Space.single),
			mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Space.single),
			mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Space.single),
			
			posterImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: Space.half),
			posterImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Space.half),
			posterImage.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor, constant: -Space.half),
			posterImage.heightAnchor.constraint(equalToConstant: 100),
			posterImage.widthAnchor.constraint(equalToConstant: 70),
			
			activityIndicator.centerYAnchor.constraint(equalTo: posterImage.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: posterImage.centerXAnchor),
			
			titlelabel.topAnchor.constraint(equalTo: mainView.topAnchor),
			titlelabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
			titlelabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Space.single),
			titlelabel.trailingAnchor.constraint(equalTo: ratingIcon.leadingAnchor),
			
			ratingIcon.centerYAnchor.constraint(equalTo: ratinglabel.centerYAnchor),
			
			ratingIcon.heightAnchor.constraint(equalTo: ratingIcon.widthAnchor),
			ratingIcon.trailingAnchor.constraint(equalTo: ratinglabel.leadingAnchor,constant: -Space.half),

			ratinglabel.topAnchor.constraint(equalTo: mainView.topAnchor),
			ratinglabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),

			ratinglabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
			ratinglabel.widthAnchor.constraint(equalToConstant: 50)
			
		]
		NSLayoutConstraint.activate(array)
	}
	
	let imageCache = MyCache.sharedInstance
	
	public func downloadItemImageForSearchResult(imageURL: URL?) {
		
		if let urlOfImage = imageURL {
			if let cachedImage = imageCache.object(forKey: urlOfImage.absoluteString as NSString){
				self.posterImage.image = cachedImage
			} else {
				let session = URLSession.shared
				activityIndicator.startAnimating()
				self.downloadTask = session.downloadTask(
					with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
						DispatchQueue.main.async() {
						if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
													
								let imageToCache = image
								
								if let strongSelf = self{
									
									strongSelf.posterImage.image = imageToCache
									
									strongSelf.imageCache.setObject(imageToCache, forKey: urlOfImage.absoluteString as NSString, cost: 1)
									strongSelf.activityIndicator.stopAnimating()
								}
								
							
						} else {
							if let strongSelf = self{
								strongSelf.activityIndicator.stopAnimating()
							}
//							print("ERROR \(error?.localizedDescription)")
						}}
					})
				self.downloadTask!.resume()
			}
		}
	}
	override func prepareForReuse() {
		//imageCache.removeObject(forKey: imageURL!.absoluteString as NSString)
		self.downloadTask?.cancel()
		self.activityIndicator.stopAnimating()
		posterImage.image = nil
		//		print("calcel")
		//		myImageView?.image = UIImage(named: "ImagePlaceholder")
	}
	//	  override public func prepareForReuse() {
	//		self.downloadTask?.cancel()
	//		myImageView?.image = UIImage(named: "ImagePlaceholder")
	//	  }
	
	deinit {
		//imageCache.removeObject(forKey: imageURL!.absoluteString as NSString)
		self.downloadTask?.cancel()
		self.activityIndicator.stopAnimating()
		posterImage.image = nil
	}
}
extension MoviesListTableViewCell {
	func fill(model:MovieModel) {
		titlelabel.text = "\(model.title)"
		imageURL = Url.getPosterURL(model:model)
		ratinglabel.text = String(model.voteAverage)
	}
}
