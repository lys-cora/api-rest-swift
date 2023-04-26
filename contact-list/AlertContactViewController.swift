import UIKit

class AlertContactViewController: UIViewController {
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemPink
//        button.addTarget(self, action: #selector(sendContact), for: .touchUpInside)
        return label
    }()
    
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cadastrar", for: .normal)
        button.backgroundColor = .systemPink
//        button.addTarget(self, action: #selector(sendContact), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Lista de contato", for: .normal)
        button.backgroundColor = .systemPink
//        button.addTarget(self, action: #selector(listPersons), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.addSubview(descriptionLabel)
        view.addSubview(updateButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            updateButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            deleteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            deleteButton.leadingAnchor.constraint(equalTo: updateButton.trailingAnchor, constant: 16)
        ])
    }
    
    
}
