//
//  CharacterListViewController.swift
//  RickAndMortyApiProject-ios
//
//  Created by Thomas on 30/04/2021.
//

import UIKit
import Moya

class CharacterListViewController: UIViewController {
    @IBOutlet weak var characterList: CharacterListCollectionView!
    
    let provider = MoyaProvider<RickAndMortyBaseApi>()
    
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready:
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
                self.characterList.setUpCollectionView(state: self.state)
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

class CharacterListCollectionView: UICollectionView {
    

    
    enum Section {
        case main
    }

    enum Item: Hashable {
        case character(CharacterRemote)
    }

    var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, environment) -> NSCollectionLayoutSection? in
            let snapshot = self.diffableDataSource.snapshot()
            

                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))

                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(150))

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 2)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 20

                return section
        })

        return layout
    }

    func createSnapshot(state: CharacterListViewController.State) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        guard case .ready(let items) = state else { return snapshot}
        
        
        snapshot.appendItems(items.map(Item.character), toSection: .main)

        return snapshot
    }
    
    func setUpCollectionView (state: CharacterListViewController.State) {
        self.collectionViewLayout = createLayout()

        diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell ?? CharacterCell()

            guard case .ready(let items) = state else { return cell }

            cell.configureWith(items[indexPath.item])

            return cell
        })

        let snapshot = createSnapshot(state: state)
        diffableDataSource.apply(snapshot)
    }
    
}

class CharacterCell: UICollectionViewCell {
    public static let reuseIdentifier = "CharacterCell"

    @IBOutlet private weak var imgThumb: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!

    public func configureWith(_ character: CharacterRemote) {
        
        lblTitle.text = character.name
        imgThumb.downloaded(from: character.image)
    }
    
    @IBAction func didTapButton() {
        let storyboard = UIStoryboard(name: "CharacterList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CharacterDetailViewController")
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
}


extension UIImageView {
    func dowloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                
            }
            
            
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            return
        }
        
        dowloaded(from: url, contentMode: mode)
    }
}
