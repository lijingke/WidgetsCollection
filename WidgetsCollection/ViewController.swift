//
//  ViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/3.
//

import Combine
import UIKit

extension Notification.Name {
    static let dataLoaded = Notification.Name("data_loaded")
}

struct Item {
    let title: String
}

enum RequestError: Error {
    case sessionError(error: Error)
}

class ViewController: BaseViewController {
    // MARK: Property

    private let titleLabel = UILabel()
    private var cancel: AnyCancellable?
    
    private let imageURLPublisher = PassthroughSubject<URL, RequestError>() // 图片加载请求发布者
    private let imageView = UIImageView()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        bindData()
    }
    
    private func bindData() {
        let publisher = NotificationCenter.Publisher(center: .default, name: .dataLoaded).map { noti -> String? in
            return (noti.object as? Item)?.title
        }
        let subscriber = Subscribers.Assign(object: titleLabel, keyPath: \.text)
        publisher.subscribe(subscriber)
        
        cancel = NotificationCenter.Publisher(center: .default, name: .dataLoaded).map { noti -> String? in
            return (noti.object as? Item)?.title
        }.sink { data in
            Log.info(data)
        }
        
        cancel = imageURLPublisher.flatMap { url in
            return URLSession.shared.dataTaskPublisher(for: url).mapError { error in
                return RequestError.sessionError(error: error)
            }
        }.sink { error in
            print(error)
        } receiveValue: { result in
            let image = UIImage(data: result.data)
            print(image)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let data = Item(title: "我是一个标题")
        NotificationCenter.default.post(name: .dataLoaded, object: data)
        print(titleLabel.text ?? "")
        imageURLPublisher.send(URL(string: "https://httpbin.org/image/jpeg")!)
    }
}

extension ViewController {
    private func setupUI() {
        view.addSubviews([titleLabel, imageView])
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
