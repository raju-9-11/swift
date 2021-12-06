//
//  ViewController.swift
//  Networking
//
//  Created by Rajkumar S on 02/12/21.
//

import UIKit
import SQLite3

internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    lazy var articles: [Article] = []
    
    var totalPages: Int = 0
    
    let searchQuery: String = "IOS"
    
    let api = API()
    
    var currPage: Int = 1
    
    let bottomContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.backgroundColor = .white.withAlphaComponent(0.8)
        return view
    }()
    
    let previousPage: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Prev", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(changePage(_:)), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        return button
    }()
    
    let nextPage: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(changePage(_:)), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        return button
    }()
    
    let dBLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading...."
        label.sizeToFit()
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let cellID = "CellID"

    override func loadView() {
        super.loadView()
        view.backgroundColor = .gray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: cellID)

        
        self.getData(url: "https://free-news.p.rapidapi.com/v1/search", query: searchQuery, pageSize: 10, page: currPage)
        
        bottomContainer.addSubview(previousPage)
        bottomContainer.addSubview(nextPage)
        view.addSubview(collectionView)
        view.addSubview(dBLabel)
        view.addSubview(bottomContainer)
        self.setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NewsCollectionViewCell
        cell.article = articles[indexPath.row]
        cell.updateLayout()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 100)
    }
    
    @objc
    func changePage(_ sender: UIButton) {
        if sender == nextPage {
            currPage += 1
        } else {
            currPage -= 1
        }
        
        if currPage == 1 {
            previousPage.isHidden = true
        } else if currPage == totalPages {
            nextPage.isHidden = true
        } else {
            previousPage.isHidden = false
            nextPage.isHidden = false
        }
        self.dBLabel.text = "Loading..."
        self.collectionView.isHidden = true
        self.getData(url: "https://free-news.p.rapidapi.com/v1/search", query: searchQuery, pageSize: 10, page: currPage)
        self.collectionView.reloadData()
    }
    
   
    func setupLayout() {
        
        self.navigationItem.title = "Search results for \(searchQuery)"
        NSLayoutConstraint.activate([
            dBLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dBLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            bottomContainer.heightAnchor.constraint(equalToConstant: 50),
            previousPage.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            previousPage.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor, constant: 10),
            nextPage.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            nextPage.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor, constant: -10),
        ])
    }


}

extension ViewController {
    // Networking calls
    
    func getData(url: String ,query: String, pageSize: Int, page: Int) {
        
        var components = URLComponents(string: url)
        components?.queryItems = [URLQueryItem(name: "q", value: query), URLQueryItem(name: "lang", value: "en"), URLQueryItem(name: "page_size", value: "\(pageSize)"), URLQueryItem(name: "page", value: "\(page)")]
        guard let myUrl = components?.url else { return }
        let request = NSMutableURLRequest(url: myUrl , cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = api.headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error")
            } else {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Dictionary<String, AnyObject>
                    let data = jsonData["articles"] as! [AnyObject]
                    self.articles = data.map({ dat in return Article(data: dat)})
                    DispatchQueue.main.async {
                        self.dBLabel.text = ""
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                        self.view.layoutIfNeeded()
                        self.totalPages = jsonData["total_pages"] as? Int ?? 0
                    }
                }
                catch {
                    print("Json Error!!")
                }
            }
        })

        dataTask.resume()
    }
}

