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
    
    lazy var articles: [Article] = [] {
        willSet {
            images = Array(repeating: UIImage(systemName: "photo.fill")!, count: newValue.count)
        }
    }
    
    var totalPages: Int = 0
    
    let searchQuery: String = "Linux"
    
    let api = API()
    
    var currPage: Int = 1
    
    var db: OpaquePointer?
    
    var images: [UIImage] = []
    
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
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        return cv
    }()
    
    let cellID = "CellID"

    override func loadView() {
        super.loadView()
        view.backgroundColor = .gray
        
        self.getData(query: searchQuery, pageSize: 20, page: currPage)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: cellID)

        
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
        cell.imageView.image = images[indexPath.row]
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
        self.getData(query: searchQuery, pageSize: 10, page: currPage)
        self.collectionView.reloadData()
    }
    
    @objc
    func reloadPage() {
        self.dBLabel.text = "Loading..."
        self.collectionView.isHidden = true
        self.getData(query: searchQuery, pageSize: 10, page: currPage)
    }
   
    func setupLayout() {
        
        self.navigationItem.title = "Search results for \(searchQuery)"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(reloadPage))
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

// MARK: - Networking calls
extension ViewController {
    
//    func getData(query: String, pageSize: Int, page: Int) {
//            Task {
//                guard let articleResponse = await API.shared.otherFetch(pageSize: pageSize, page: page, query: query) else { self.loadDataFromLocalDB(); return }
//                self.dBLabel.text = ""
//                self.articles = articleResponse.articles
//                self.collectionView.reloadData()
//                self.view.layoutIfNeeded()
//                self.collectionView.isHidden = false
//                self.totalPages = articleResponse.total_pages
//                self.saveToLocalDB()
//                if self.articles.count > 0 {
//                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//                }
//                for (index, article) in articleResponse.articles.enumerated() {
//                    guard let media = article.media, let url = URL(string: media) else { continue }
//                    self.downloadImage(from: url, completion: { (data, response, error) -> Void in
//                        if error == nil {
//                            self.images[index] = UIImage(data: data!) ?? UIImage(systemName: "photo.fill")!
//                            self.collectionView.reloadData()
//                        }
//                    })
//                }
//            }
//
//    }
    
//    func downloadImage(from url: URL?, completion: @escaping (Data? , URLResponse? , Error? ) -> Void) {
//        guard let url = url else { return }
//        Task {
//            do {
//                let (data, response) = try await URLSession.shared.data(from: url)
//                completion(data, response, nil)
//            }
//            catch {
//                completion(nil,nil,error)
//            }
//        }
//    }
    
    func getData(query: String, pageSize: Int, page: Int) {
        DispatchQueue.global(qos: .background).async {
            API.shared.fetchArticles(pageSize: pageSize, page: page, query: query, completion: { (result) in
                switch result {
                case .success(let articleResponse):
                    DispatchQueue.main.async {
                        self.dBLabel.text = ""
                        self.articles = articleResponse.articles
                        self.collectionView.reloadData()
                        self.view.layoutIfNeeded()
                        self.collectionView.isHidden = false
                        self.totalPages = articleResponse.total_pages
                        self.saveToLocalDB()
                        if self.articles.count > 0 {
                            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        }
                    }
                    for (index, article) in articleResponse.articles.enumerated() {
                        guard let media = article.media, let url = URL(string: media) else { continue }
                        self.downloadImage(from: url, completion: { data, response, error in
                            if error == nil {
                                self.images[index] = UIImage(data: data!) ?? UIImage(systemName: "photo.fill")!
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            }
                        })
                    }
                case .failure(let err):
                    print(err)
                }
            })
        }
               
    }
    
    func downloadImage(from url: URL?, completion: @escaping (Data? , URLResponse? , Error? ) -> Void) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: - SQL
    
    func loadDataFromLocalDB() {
        let alert = UIAlertController(title: "Data not available", message: "You are not connected to internet or the api is unavailable", preferredStyle: .alert)
        let action = UIAlertAction(title: "View offline data", style: .default, handler: {
            _ in
            if self.initSQLDB(dbName: "Testing") {
                if self.initTable() {
                    self.dBLabel.text = "Loading data from SQL.."
                    self.readFrom()
                    self.collectionView.reloadData()
                    self.dBLabel.text = ""
                    self.collectionView.isHidden = false
                    self.bottomContainer.isHidden = true
                }
            }
        })
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func saveToLocalDB() {
        if self.initSQLDB(dbName: "Testing") {
            self.clearLocalData()
            if self.initTable() {
                for article in articles[..<min(10, articles.count)] {
                    self.insertInto(title: article.title, summary: article.summary, topic: article.topic)
                }
                self.bottomContainer.isHidden = false
            }
        }

    }
    
    func initSQLDB(dbName : String) -> Bool {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(dbName).sqlite")
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return false
        }
        return true
    }
    
    
    
    func initTable() -> Bool {
        if sqlite3_exec(db, "create table if not exists article_table (id integer primary key autoincrement, title text, summary text, topic text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        return true
    }
    
    func clearLocalData() {
        sqlite3_exec(db, "drop table article_table", nil, nil, nil)
    }
    
    func insertInto(title: String, summary: String, topic: String) {
        var statement: OpaquePointer?

        sqlite3_prepare_v2(db, "insert into article_table (title, summary, topic) values (?,?,?)", -1, &statement, nil)
        sqlite3_bind_text(statement, 1, "\(title)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 2, "\(summary)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 3, "\(topic)", -1, SQLITE_TRANSIENT)
        sqlite3_step(statement)
        
    }
    
    func readFrom() {
        
        var statement: OpaquePointer?
        
        sqlite3_prepare_v2(db, "select id, title, summary, topic from article_table", -1, &statement, nil)
        self.articles = []
        
        var articleId: String = ""
        var articleTitle: String = ""
        var articleSummary: String = ""
        var articleTopic: String = ""
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            articleId = "\(id)"

            if let cString = sqlite3_column_text(statement, 1) {
                let title = String(cString: cString)
                articleTitle = title
            }
            
            if let cString = sqlite3_column_text(statement, 2) {
                let summary = String(cString: cString)
                articleSummary = summary
            }
            
            if let cString = sqlite3_column_text(statement, 3) {
                let topic = String(cString: cString)
                articleTopic = topic
            }
            
            self.articles.append(Article(_id: articleId, title: articleTitle, summary: articleSummary, topic: articleTopic))
            
        }

    }

}

