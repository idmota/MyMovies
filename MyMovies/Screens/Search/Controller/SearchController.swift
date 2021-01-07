//
//  SearchController.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import UIKit

class SearchController: UIViewController {
	var presenter: SearchPresenterInput!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchController: SearchProtocol {

	func succes() {
		
	}
	
	func failure(error: Error) {
		
	}
	
	
}
