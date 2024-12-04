//
//  SearchViewModel.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/15.
//

import Combine
import Foundation

class ViewModel: ObservableObject {
    /// 搜索关键字Publisher，用于启动Combine流程
    var searchPublisher = PassthroughSubject<String, Never>()
    private var cancellable = Set<AnyCancellable>()

    init() {
        searchPublisher
            .print("_Combine_")

            // MARK: - 通过PassthroughSubject订阅关键字变化

            //         通过flatMap转换Publisher为Publisher<StockInfo, Error>
            //         通过search查询关键字
            .flatMap { searchContent in
                self.search(searchContent)
            }

            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("finished")
                case let .failure(error):
                    print("sink error: \(error)")
                }
            } receiveValue: { [weak self] searchResult in
                print("receiveValue: \(searchResult)")
                // 搜索后获得数据，可存储到ViewModel中的@Published变量，来刷新View视图
            }
            .store(in: &cancellable)
    }

    /// 按照关键字搜索 ，返回为Publisher
    /// - Parameters:
    ///   - text: 关键字
    /// - Returns: AnyPublisher<StockInfo, Error>
    public func search(_ text: String) -> AnyPublisher<StockInfo, Error> {
        let url = URL(string: "your request url" + text)
        guard let url = url else {
            // url失败返回一个错误Publisher
            return Fail(error: APIError.badURL).eraseToAnyPublisher()
        }

        // 网络请求Publisher
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(2)
            .map { $0.data }
            .decode(type: StockInfo.self, decoder: JSONDecoder())
            .replaceError(with: StockInfo())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    // 错误枚举定义
    enum APIError: Error, CustomStringConvertible {
        case badURL
        case badNetwork(error: Error)
        case badDecode
        case unknown

        var description: String {
            switch self {
            case .badURL:
                return "_URL Invalided_"
            case let .badNetwork(error):
                return "_network error: \(error.localizedDescription)_"
            case .badDecode:
                return "_decode error_"
            case .unknown:
                return "_unknown error_"
            }
        }
    }
}

struct StockInfo: Decodable {}
