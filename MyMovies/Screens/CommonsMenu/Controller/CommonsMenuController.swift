//
//  CommonsMenuController.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import UIKit

class CommonsMenuController: UIViewController {
	
	var presenter: CommonsMenuPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
		setipView()
    }
	
	private func setipView() {
		[
			menuTable
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}

		setypLayout()
	}
	
	private func setypLayout() {
		let array = [
			menuTable.topAnchor.constraint(equalTo: view.topAnchor),
			menuTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			menuTable.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -Space.heghtBottomControlPanel),
			menuTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		]
		NSLayoutConstraint.activate(array)
	}
	lazy var menuTable:UITableView = {
		let t = UITableView()
		t.register(CommonsMenuTableViewCell.self)
		t.delegate = self
		t.dataSource = self
		t.separatorStyle = .none
		
		return t
	}()
	
	@objc func didHideMenu() {
		presenter.didHideMenu(animation: true)
	}

}
extension CommonsMenuController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.totalCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:CommonsMenuTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		cell.make(menuModel: presenter.itemMenu(at: indexPath.row))
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		print("did open \(indexPath.row)")
		presenter.didOpenScreen(at: indexPath.row)
	}
}
extension CommonsMenuController: CommonsMenuControllerProtocol {
	
}


