
import UIKit

class commentTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "commentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        self.tableView.rowHeight = 200
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
    }
    
    func setUpCommentsView(margins: UILayoutGuide){
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.3),
            view.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.7)
        ])
        
        view.layer.cornerRadius = 20.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! softCommentTableViewCell
        cell.updateText()
 
        return cell
    }

}
