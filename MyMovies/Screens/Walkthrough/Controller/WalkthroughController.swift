//
//  WalkthroughController.swift
//  MyMovies
//
//  Created by link on 12/16/20.
//

import UIKit



class WalkthroughController: UIViewController  {
	
	var presenter: WalkthroughPresenter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		navigationController?.isNavigationBarHidden = true
		setupView()
	}
	
	private func setupView() {
		
		[
			collectionView,
			pageControll,
			button
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		setupLayout()
	}
	private func setupLayout() {
		let array = [
			
			pageControll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pageControll.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -Space.quadruple),
			
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
			button.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.6),
			button.heightAnchor.constraint(equalToConstant: 50),
			
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			
		]
		
		NSLayoutConstraint.activate(array)

	}
	
	
	lazy var mainview:UIView = {
		let v = UIView()
		return v
	}()

	override func viewDidLayoutSubviews() {
//		super.viewDidLayoutSubviews()
		colViewLayout.itemSize = collectionView.frame.size
	}
	
	lazy var pageControll: UIPageControl = {
		let pc = UIPageControl()
		pc.numberOfPages = 0
		pc.currentPage = 0
		pc.backgroundStyle = .minimal

		pc.isUserInteractionEnabled = false
		let img = UIImage(named: "select")

		pc.preferredIndicatorImage = img

		return pc
	}()
	
	lazy var colViewLayout: UICollectionViewFlowLayout = {
		
		let cvl = UICollectionViewFlowLayout()
		cvl.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

		cvl.scrollDirection = .horizontal
		cvl.minimumLineSpacing = 0
		
		return cvl
	}()
	let button: UIButton = {
		let b = UIButton()
		b.setTitle("Next →", for: .normal)
		b.layer.cornerRadius = 25
		b.layer.borderWidth = 2
		b.layer.borderColor = UIColor.white.cgColor
		b.clipsToBounds = true
		b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		b.addTarget(self, action: #selector(actionNextPage), for: .touchUpInside)
		return b
	}()
	@objc func actionNextPage() {
		if pageControll.currentPage < pageControll.numberOfPages-1 {
		
			let newContentSize = self.collectionView

			UIView.animate(withDuration: 0.2, animations: { [self] in
				let newPage = CGFloat(pageControll.currentPage+1)
				let newOffset = CGPoint(x: newContentSize.frame.width*newPage+colViewLayout.minimumLineSpacing*newPage, y: newContentSize.contentOffset.y)
				self.collectionView.setContentOffset(newOffset, animated: true)
			})
			
		} else if pageControll.currentPage == pageControll.numberOfPages-1 {
			presenter.didOpenMainViewController()
		}
		
	}
	lazy var collectionView: UICollectionView = {
		let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: colViewLayout)
		cv.register(WalkthroughCollectionViewCell.self)
		
		cv.backgroundColor = ColorMode.background
		cv.delegate = self
		cv.dataSource = self
		cv.isPagingEnabled = true
		cv.contentInsetAdjustmentBehavior = .never
		cv.showsHorizontalScrollIndicator = false
		
		return cv
	}()
	
	lazy var gradientLayer: CAGradientLayer = {
		let gradient = CAGradientLayer()
		let l1 = ColorMode.color1.withAlphaComponent(1)
		let l2 = ColorMode.color2.withAlphaComponent(1)

		gradient.colors = [l1.cgColor,l2.cgColor]
		gradient.startPoint = CGPoint(x:  0.25, y: 0)
		gradient.endPoint = CGPoint(x: 0.75, y: 0.9)

		return gradient
	}()
}

extension WalkthroughController: UICollectionViewDelegate, UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		pageControll.numberOfPages = presenter.totalCount
		return presenter.totalCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:WalkthroughCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.make(model: presenter.walkthrough(at: indexPath.row))
		
		return cell
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let oldPage = pageControll.currentPage
		let scrollPos = scrollView.contentOffset.x / scrollView.frame.width
		pageControll.currentPage = Int(round(scrollPos))
		if oldPage != pageControll.currentPage {
			if pageControll.currentPage==pageControll.numberOfPages-1 {
				button.setTitle("Get Stared", for: .normal)
				let gl = gradientLayer
				gl.frame = button.bounds
				button.layer.insertSublayer(gl, at: 0)
				button.layer.borderWidth = 0
			} else {
				button.setTitle("Next →", for: .normal)
				button.layer.borderWidth = 2
				button.layer.sublayers?.removeAll(where: {$0 is CAGradientLayer})
			}
		}
	}

}
