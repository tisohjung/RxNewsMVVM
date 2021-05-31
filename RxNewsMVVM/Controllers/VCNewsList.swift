//
//  VCNewsList.swift
//  RxNewsMVVM
//
//  Created by minho on 2021/05/31.
//

import UIKit
import RxSwift

class VCNewsList: UITableViewController {
    let disposeBag: DisposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true

        fetchNews()
    }

    func fetchNews() {
        URLRequest.load(resource: ArticleResponse.resource)
            .subscribe(onNext: { [weak self] result in
                self?.articleListVM = ArticleListViewModel(result.articles)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.articlesVM.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ArticleTableViewCell.self)", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell not found")
        }

        let articleVM = articleListVM.articleAt(indexPath.row)
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)

        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        return cell
    }
}
