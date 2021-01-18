//
//  MovieDetailController.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit
import Foundation
//import youtube_ios_player_helper

class MovieDetailController: UIViewController {
	var presenter: MovieDetailPresenter!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = ColorMode.background
		
//		navigationController?.hidesBarsOnSwipe = false
		navigationController?.isNavigationBarHidden = true

		view = DetailView(delegate: self)
		setupView()
	}

	lazy var navigView:UIView = {
		let v = UIView()
		let color = UIColor.lightGray
		
		v.backgroundColor = color.withAlphaComponent(0.2)
		v.translatesAutoresizingMaskIntoConstraints = false

		return v
	}()
	
	lazy var backButton:UIButton = {
		let bb = UIButton()
		bb.addTarget(self, action: #selector(backAction), for: .touchUpInside)
		bb.setTitle(" Back", for: .normal)
		let img = UIImage(systemName: "arrow.uturn.left")

		bb.setImage(img?.withTintColor(ColorMode.background, renderingMode: .alwaysOriginal), for: .normal)
		bb.setTitleColor(ColorMode.background, for: .normal)
		return bb
	}()
	
	lazy var shareButton:UIButton = {
		let sb = UIButton()
		sb.setImage(UIImage(named: "shareico")?.withTintColor(ColorMode.background, renderingMode: .alwaysOriginal), for: .normal)
		sb.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
//		sb.setTitle("", for: .normal)
//		sb.setTitleColor(ColorMode.titleColor, for: .normal)
		return sb
	}()
	
	func setupView() {
		[
		backButton,
		shareButton
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			navigView.addSubview($0)
		}
		view.addSubview(navigView)

		setupLayout()
	}
	func setupLayout() {
		let constraints = [
			
			navigView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			navigView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			navigView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			backButton.topAnchor.constraint(equalTo: navigView.topAnchor, constant: Space.single),
			backButton.leadingAnchor.constraint(equalTo: navigView.leadingAnchor, constant: Space.single),
			backButton.bottomAnchor.constraint(equalTo: navigView.bottomAnchor, constant: -Space.single),
			
			shareButton.topAnchor.constraint(equalTo: navigView.topAnchor, constant: Space.single),
			shareButton.trailingAnchor.constraint(equalTo: navigView.trailingAnchor, constant: -Space.single),
			shareButton.bottomAnchor.constraint(equalTo: navigView.bottomAnchor, constant: -Space.single)
			
		]
		NSLayoutConstraint.activate(constraints)
		
	}
	
	@objc func backAction() {
		navigationController?.popViewController(animated: true)
	}
	@objc func shareAction() {
		// mb youtube link
		let activityViewController = UIActivityViewController(activityItems: [presenter.movie!.originalTitle], applicationActivities: .none)
		self.present(activityViewController, animated: true, completion: nil)
	}
	
}

extension MovieDetailController: MovieDetailViewDelegateOutput {
	
	func dowloadPictures(pathURL: URL?, completion: @escaping (UIImage?) -> Void) {
		presenter.dowloadPictures(pathURL: pathURL, completion: completion)
	}
}
	
extension MovieDetailController: MovieDetailProtocol {
	func succes() {
		guard let vv = view as? MovieDetailViewDelegateInput else {
			return
		}
		vv.fillViewFromModel(model:presenter.movie!)
		
	}
	
	func failure(error: Error) {
		Logger.handleError(error)
	}
	
	
}
