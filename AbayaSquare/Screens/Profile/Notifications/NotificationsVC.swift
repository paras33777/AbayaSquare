//
//  NotificationsVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var notificationsTV: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    let viewModel = NotificationsViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications".localized
        setupRefreshControl()
        if User.isLoggedIn {
            setupBarButton()
            getNotifications()
        }
    }
}

extension NotificationsVC {
    
    private func setupBarButton(){
        let clearButton = UIButton()
        clearButton.setTitle("Clear All".localized, for: .normal)
        clearButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        clearButton.setTitleColor(UIColor("#333333"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: clearButton)
        clearButton.addTarget(self, action: #selector(clearAllNotifications(_:)), for: .touchUpInside)
    }
    
    func setupRefreshControl() {
        notificationsTV.refreshControl = UIRefreshControl()
        notificationsTV.refreshControl?.tintColor = .black
        notificationsTV.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    @objc func startAPI(){
        viewModel.getNotifications() {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func getNotifications(){
        view.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    func onSuccess(_ response: NotificationsModel.Response){
        removeSpinner()
        notificationsTV.refreshControl?.endRefreshing()
        viewModel.notifications = response.notifcations ?? []
        checkEmpty()
        notificationsTV.reloadData()
    }
    
    func checkEmpty(){
        viewModel.notifications.isEmpty ? (emptyView.isHidden = false ) : (emptyView.isHidden = true)
    }
    
    @objc func clearAllNotifications(_ sender: UIButton){
        alertWithCancel(title: "Delete All Notifications".localized, message: "Do You Want to Delete All Notifications".localized,OkAction: "Delete".localized) {_ in
            sender.showSpinner(spinnerColor: .black,backgroundColor:  UIColor("#E4D7C4").withAlphaComponent(0.4))
            self.viewModel.clearAllNotifications {result in
                self.removeSpinner()
                switch result {
                case .success(_):
                    MainHelper.shared.showSuccessMessage(responseMessage: "All Notification Has been Deleted".localized)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error): self.onFailure(error)
                }
            }
        }
    }
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let model = viewModel.notifications[indexPath.row]
        cell.delegate = self
        cell.config(with: model)
        return cell
    }
}

extension NotificationsVC: NotificationCellDelegate {
    func didDeleteNotification(_ cell: NotificationCell) {
        if let row = notificationsTV.indexPath(for: cell)?.row {
            let request = NotificationsModel.DeleteNotification(id: viewModel.notifications[row].id)
            cell.showSpinner(spinnerColor: .black, backgroundColor: .clear)
            viewModel.deleteNotificaton(request: request) {result in
                switch result {
                case .success(_):
                    MainHelper.shared.showSuccessMessage(responseMessage: "Notification has Been Deleted".localized)
                    self.viewModel.notifications.remove(at: row)
                    self.notificationsTV.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                    self.notificationsTV.reloadData()
                    self.checkEmpty()
                case .failure(let error): self.onFailure(error)
                }
            }
        }
    }
}

//extension NotificationsVC: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] action, indexPath in
//            let cell = notificationsTV.cellForRow(at: indexPath) as! NotificationCell
//            let request = NotificationsModel.DeleteNotification(id: viewModel.notifications[indexPath.row].id)
//            cell.showSpinner(spinnerColor: .black, backgroundColor: .clear)
//            viewModel.deleteNotificaton(request: request) {result in
//                switch result {
//                case .success(_):
//                    MainHelper.shared.showSuccessMessage(responseMessage: "Notification has Been Deleted".localized)
//                    viewModel.notifications.remove(at: indexPath.row)
//                    notificationsTV.deleteRows(at: [indexPath], with: .automatic)
//                    notificationsTV.reloadData()
//                    checkEmpty()
//                case .failure(let error): self.onFailure(error)
//                }
//            }
//        }
//        deleteAction.image = UIImage(named: "ic_delete")
//        deleteAction.backgroundColor = UIColor("#F44848")
//        deleteAction.textColor = .clear
//        return [deleteAction]
//    }
//}
