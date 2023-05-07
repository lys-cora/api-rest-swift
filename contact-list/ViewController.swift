import UIKit
import UserNotifications


enum APIError: Error {
    case serverError
    case invalidURL
    case requestFailed
    case invalidResponse
    case invalidData
    case decodingFailed
}

class ViewController: UIViewController {
    
    private var wasAllowed: Bool?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        button.addTarget(self, action: #selector(sendContact), for: .touchUpInside)
        return button
    }()
    
    private lazy var queryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Lista de contatos", for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(listPersons), for: .touchUpInside)
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Manda alarme", for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(receiveNotification), for: .touchUpInside)
        return button
    }()
    
    @objc func receiveNotification() {
        
        let center = UNUserNotificationCenter.current()
    
        // Create a notification content object
        let content = UNMutableNotificationContent()
        content.title = "My Notification Title"
        content.body = "This is my notification message."
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "my-audio.mp3"))
        
        // Create the date components for the alarm
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 32

        // Create a notification trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // Create a notification request
        let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
        
        center.requestAuthorization(options: [.alert, .sound, .criticalAlert]) { granted, error in
            if granted {
                self.addCenterRequest(center: center, request: request)
                print("Permission granted!")
            } else {
                print("Permission denied.")
            }
        }
    }
    
    func addCenterRequest(center: UNUserNotificationCenter, request: UNNotificationRequest) {
        center.add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification request added successfully!")
            }
        }
    }
    
    @objc func sendContact() {
        let contact = Contact(name: nameTextField.text!, phone: phoneTextField.text!)
        print(contact)
        createContact(contact: contact) { result in
            switch result {
            case .success(let success):
                print("sucesso do result")
                print(success)
            case .failure(let failure):
                print("falha do result")
                print(failure)
            }
        }
    }
    
    @objc func listPersons() {
        getPersons { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    let controller = ListContactsTableViewController(people: success)
//                    self.navigationController?.pushViewController(controller, animated: true)
                    self.present(controller, animated: true)
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    @objc func updatePerson() {
        
    }
    
    func getPersons(completion: @escaping (Result<[Person], APIError>) -> Void) {
        // create a URL object
        let url = URL(string: "https://lssev-people-management.herokuapp.com/person")
        
        // create a URLSession object
        let session = URLSession.shared
        
        // create a data task for the GET request
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            let decoder = JSONDecoder()
            do {
                if let data = data {
                    let person = try decoder.decode([Person].self, from: data)
                    completion(.success(person))
                    print(person)
                }
            } catch {
                print("Failed to decode JSON data: \(error)")
            }
            
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
                print("No data received")
                return
            }
        }
        
        
        
        // start the data task
        task.resume()
    }
    
    func createContact(contact: Contact, completion: @escaping (Result<Person, APIError>) -> Void) {
        
        guard let url = URL(string: "https://lssev-people-management.herokuapp.com/person") else { completion(.failure(.invalidURL))
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(contact)
        } catch {
            completion(.failure(.requestFailed))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                
                let person = try decoder.decode(Person.self, from: data)
                completion(.success(person))
                print(person)
            } catch {
                completion(.failure(.decodingFailed))
                print("Failed to decode JSON data: \(error)")
            }
        }
        task.resume()
    }
    
    func updateContact(id: String, name: String?, phone: String?, completion: @escaping (Result<Person, APIError>) -> Void) {
        
        guard let url = URL(string: "https://lssev-people-management.herokuapp.com/person/\(id)") else { completion(.failure(.invalidURL))
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let contact = Contact(name: name ?? "Nome não encontrado", phone: phone)
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(contact)
        } catch {
            completion(.failure(.requestFailed))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                
                let person = try decoder.decode(Person.self, from: data)
                completion(.success(person))
                print(person)
            } catch {
                completion(.failure(.decodingFailed))
                print("Failed to decode JSON data: \(error)")
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateContact(id: "1", name: "Jim Santos", phone: "+55 13 4545-0909") { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
        
        navigationItem.title = "Contatos"
//        navigationBar.barStyle = .black
        
        view.backgroundColor = .systemPurple
        // Do any additional setup after loading the view.
        
        view.addSubview(nameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(registerButton)
        view.addSubview(queryButton)
        view.addSubview(notificationButton)
        
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
            
            notificationButton.topAnchor.constraint(equalTo: queryButton.bottomAnchor, constant: 20),
            notificationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    
}

