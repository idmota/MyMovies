//
//  MovieGenreList.swift
//  MyMovies
//
//  Created by link on 11/20/20.
//

import UIKit



class MovieGenreListController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	var presenter: MovieGenrePresenter!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

  
	
}
extension MovieGenreListController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.genreLists?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
			return UITableViewCell()
		}
		let text = presenter.genreLists?[indexPath.row].name ?? ""
		cell.textLabel?.text = text
		cell.textLabel?.textColor = .cyan
		return cell
	}
	

}
extension MovieGenreListController: MovieGenreProtocol {
	func succes() {
		tableView.reloadData()
	}
	
	func failure(error: Error) {
		print(error.localizedDescription)
	}
	
}
