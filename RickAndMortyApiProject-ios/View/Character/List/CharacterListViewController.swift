//
//  CharacterListViewController.swift
//  RickAndMortyApiProject-ios
//
//  Created by Thomas on 30/04/2021.
//

import UIKit
import Moya

class CharacterListViewController: UIViewController {
    
    let provider = MoyaProvider<RickAndMortyBaseApi>()
    
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready(let item):
            print("ready")
        case .loading:
            print("loading")
        case .error:
            print("error")
        }
      }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        state = .loading
        
        provider.request(.characters) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
              self.state = .ready(try response.map(RickAndMortyResponse<CharacterRemote>.self).results)
            } catch {
                print(error)
              self.state = .error
            }
          case .failure:
            self.state = .error
          }
        }
        
        
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

extension CharacterListViewController {
  enum State {
    case loading
    case ready([CharacterRemote])
    case error
  }
}
