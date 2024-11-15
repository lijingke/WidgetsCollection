//
//  ViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/3.
//

import Combine
import UIKit
import Combine

extension Notification.Name {
    static let dataLoaded = Notification.Name("data_loaded")
}

struct Item {
    let title: String
}

enum RequestError: Error {
    case sessionError(error: Error)
}

public enum SubjectError: Error {
    case genericSubjectError
}

class ViewController: BaseViewController {
    // MARK: Property

    private let titleLabel = UILabel()
    private var cancel: AnyCancellable?
    private var photoCancel: AnyCancellable?

    private let imageURLPublisher = PassthroughSubject<URL, RequestError>() // 图片加载请求发布者
    private let imageView = UIImageView()
    var vm = ViewModel()
    
    lazy var gradientImageView: GradientImageView = {
        let view = GradientImageView(colors: [.green, .blue, .yellow], gradientDirection: .downUp)
        view.contentMode = .scaleAspectFit
        view.colors = [.green, .blue, .yellow]
        return view
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        bindData()

        vm.searchPublisher.send("搜索关键字")
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

        photoCancel = [1, 2, 3].publisher.flatMap({ int in
            // 转换原publisher为新publisher
            // 新publisher的Output为Range类型
            return (0..<int).publisher
        }).sink(receiveCompletion: { _ in }, receiveValue: { value in
            print("value: \(value)")
        })

        return

//        cancel = imageURLPublisher.flatMap { url in
//            URLSession.shared.dataTaskPublisher(for: url).mapError { error in
//                RequestError.sessionError(error: error)
//            }
//        }.sink { error in
//            print(error)
//        } receiveValue: { result in
//            let image = UIImage(data: result.data)
//            print(image)
//            DispatchQueue.main.async {
//                self.imageView.image = image
//            }
//        }

//        photoCancel = imageURLPublisher.flatMap { url in
//            URLSession.shared.dataTaskPublisher(for: url).mapError { error in
//                RequestError.sessionError(error: error)
//            }
//        }.map({ result -> UIImage? in
//            return UIImage(data: result.data)
//        }).catch({ error -> Just<UIImage?> in
//            let placeImage = UIImage(named: "cat")
//            return Just(placeImage)
//        }).sink(receiveValue: { image in
//            print(image)
//            DispatchQueue.main.async {
//                self.imageView.image = image
//            }
//        })

                photoCancel = imageURLPublisher.flatMap { url in
                    URLSession.shared.dataTaskPublisher(for: url).mapError { error in
                        RequestError.sessionError(error: error)
                    }
                }.map({ result -> UIImage? in
                    return UIImage(data: result.data)
                }).replaceError(with: UIImage(named: "cat")).sink(receiveValue: { image in
                    print(image)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                })

//
//        let subject = PassthroughSubject<String, Error>()
//        cancel = subject
//            .assertNoFailure()
//            .sink(receiveCompletion: { never in
//
//            }, receiveValue: { value in
//                Log.info(value)
//            })
//        subject.send("数据")
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        let data = Item(title: "我是一个标题")
        NotificationCenter.default.post(name: .dataLoaded, object: data)
        print(titleLabel.text ?? "")
        imageURLPublisher.send(URL(string: "htps://httpbin.org/image/j")!)
    }
}

extension ViewController {
    private func setupUI() {
        view.addSubviews([titleLabel, imageView, gradientImageView])
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        gradientImageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(100)
        }
    }
}
