//
//  CharacterDetailViewController.swift
//  RickAndMortyApiProject-ios
//
//  Created by Thomas on 02/05/2021.
//

import UIKit
import Moya

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var characterImg: UIImageView!
    var characterId : Int?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Specie: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var statut: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var numberEpisode: UILabel!
    
    let provider = MoyaProvider<RickAndMortyBaseApi>()
    
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready(let item):
            print("ready")
            characterImg.dowloaded(from: URL(string: item.image)!)
            name.text = item.name
            Specie.text = item.species
            genre.text = item.gender
            statut.text = item.status
            origin.text = item.origin.name
            numberEpisode.text = String(item.episode.count)
        case .loading:
            print("loading")
        case .error:
            print("error")
        }
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        super.viewDidLoad()

        state = .loading
        
        provider.request(.character(id: characterId ?? 1)) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                self.state = .ready(try response.map(CharacterRemote.self))
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

extension CharacterDetailViewController {
  enum State {
    case loading
    case ready(CharacterRemote)
    case error
  }
}
