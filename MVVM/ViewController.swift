//
//  ViewController.swift
//  MVVM
//
//  Created by admin on 16/3/24.
//

import UIKit
import Combine

class ViewController: UITableViewController {

  let viewModel = TodoViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .green
    tableView.delegate = self
    tableView.dataSource = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}


extension ViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = indexPath.row.description
    return cell
  }
}

extension ViewController: UITabBarDelegate {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let vc = DemoSwiftUIViewController(viewModel: viewModel)
      navigationController?.pushViewController(vc, animated: true)
    } else if indexPath.row == 1 {
      let vc = DemoSwiftUIViewController(viewModel: viewModel)
      navigationController?.pushViewController(vc, animated: true)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: .main)
      let vc = storyboard.instantiateViewController(withIdentifier: "111") as! DemoSwiftUIViewWithVC
      vc.viewModel = viewModel
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

class DemoSwiftUIViewWithVC: UIViewController {
  
  var viewModel: TodoViewModel!
  
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var uikitLabel: UILabel!
  
  open var cancellable = Set<AnyCancellable>()
  
  init(viewModel: TodoViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let statsview = DemoSwiftUIView(viewModel: viewModel)
    containerView.addConstrained(subview: statsview)
    viewModel.todosAnyPublisher
      .sink { [weak self] items in
        guard let self else { return }
        self.uikitLabel.text = items.count.description
      }
      .store(in: &cancellable)
  }
}

extension UIView {
  func addConstrained(subview: UIView) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
    subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
    subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
}
