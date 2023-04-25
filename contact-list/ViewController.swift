//
//  ViewController.swift
//  contact-list
//
//  Created by Cora on 24/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cadastrar", for: .normal)
        button.backgroundColor = .systemPink
        return button
    }()
    
    private lazy var queryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Lista de contato", for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(listContacts), for: .touchUpInside)
        return button
    }()
    
    @objc func listContacts() {
        getContacts()
        
        let controller = ListContactViewController()
        present(controller, animated: true)
    }
    
    func getContacts() {
        // create a URL object
        let url = URL(string: "https://z1e5l.wiremockapi.cloud/json/1")
        
        // create a URLSession object
        let session = URLSession.shared
        
        // create a data task for the GET request
        let task = session.dataTask(with: url!) { (data, response, error) in
            // handle any errors
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            
            
            // ensure that we received a response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            // ensure that the response status code is in the 200 range
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected status code: \(httpResponse.statusCode)")
                return
            }
            
            // ensure that we received data
            guard let responseData = data else {
                let decoder = JSONDecoder()
                do {
                    if let data = data {
                        let person = try decoder.decode(Contact.self, from: data)
                        print(person)
                    }
                } catch {
                    print("Failed to decode JSON data: \(error)")
                }
                print("No data received")
                return
            }
            
            // convert the response data to a string
            let responseString = String(data: responseData, encoding: .utf8)
            
            // do something with the response string
            print(responseString)
        }
        
        // start the data task
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPurple
        // Do any additional setup after loading the view.
        
        view.addSubview(nameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(registerButton)
        view.addSubview(queryButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            registerButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 40),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            queryButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            queryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            queryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    
}

