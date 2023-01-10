//
//  Go23CodableDefault.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

public protocol DecodableDefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

public enum DecodableDefault {}

extension DecodableDefault {
    @propertyWrapper
    public struct Wrapper<Source: DecodableDefaultSource> {
        public typealias Value = Source.Value
        public var wrappedValue = Source.defaultValue
        
        public init(wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}

extension DecodableDefault.Wrapper: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}

extension KeyedDecodingContainer {
    public func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type,
                   forKey key: Key) throws -> DecodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: T.defaultValue)
    }
}

public extension DecodableDefault {
    typealias Source = DecodableDefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Map = Decodable & ExpressibleByDictionaryLiteral

    enum Sources {
        public enum True: Source { public static var defaultValue: Bool { true } }
        public enum False: Source {public  static var defaultValue: Bool { false } }
        public enum EmptyString: Source {public  static var defaultValue: String { "" } }
        public enum EmptyList<T: List>: Source {public  static var defaultValue: T { [] } }
        public enum EmptyMap<T: Map>: Source {public  static var defaultValue: T { [:] } }
        public enum Zero: Source {public  static var defaultValue: Int { 0 } }
        public enum ZeroDouble: Source {public  static var defaultValue: Double { 0.00 } }
    }
}

public extension DecodableDefault {
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
    typealias Zero = Wrapper<Sources.Zero>
    typealias ZeroDouble = Wrapper<Sources.ZeroDouble>
}

extension DecodableDefault.Wrapper: Equatable where Value: Equatable {}
extension DecodableDefault.Wrapper: Hashable where Value: Hashable {}

extension DecodableDefault.Wrapper: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
