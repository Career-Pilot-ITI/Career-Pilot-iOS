import Foundation

struct PageableInfo: Decodable {
    let paged: Bool
    let pageNumber: Int
    let pageSize: Int
    let unpaged: Bool
    let offset: Int
    let sort: SortInfo

    init(paged: Bool, pageNumber: Int, pageSize: Int, unpaged: Bool, offset: Int, sort: SortInfo) {
        self.paged = paged; self.pageNumber = pageNumber; self.pageSize = pageSize
        self.unpaged = unpaged; self.offset = offset; self.sort = sort
    }
}

struct SortInfo: Decodable {
    let sorted: Bool
    let unsorted: Bool
    let empty: Bool

    init(sorted: Bool, unsorted: Bool, empty: Bool) {
        self.sorted = sorted; self.unsorted = unsorted; self.empty = empty
    }
}

struct PageResponse<T: Decodable>: Decodable {
    let totalElements: Int
    let totalPages: Int
    let pageable: PageableInfo
    let last: Bool
    let first: Bool
    let numberOfElements: Int
    let size: Int
    let content: [T]
    let number: Int
    let sort: SortInfo
    let empty: Bool

    init(
        totalElements: Int,
        totalPages: Int,
        pageable: PageableInfo,
        last: Bool,
        first: Bool,
        numberOfElements: Int,
        size: Int,
        content: [T],
        number: Int,
        sort: SortInfo,
        empty: Bool
    ) {
        self.totalElements    = totalElements
        self.totalPages       = totalPages
        self.pageable         = pageable
        self.last             = last
        self.first            = first
        self.numberOfElements = numberOfElements
        self.size             = size
        self.content          = empty ? [] : content
        self.number           = number
        self.sort             = sort
        self.empty            = empty
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        totalElements    = try container.decode(Int.self,          forKey: .totalElements)
        totalPages       = try container.decode(Int.self,          forKey: .totalPages)
        pageable         = try container.decode(PageableInfo.self, forKey: .pageable)
        last             = try container.decode(Bool.self,         forKey: .last)
        first            = try container.decode(Bool.self,         forKey: .first)
        numberOfElements = try container.decode(Int.self,          forKey: .numberOfElements)
        size             = try container.decode(Int.self,          forKey: .size)
        number           = try container.decode(Int.self,          forKey: .number)
        sort             = try container.decode(SortInfo.self,     forKey: .sort)
        empty            = try container.decode(Bool.self,         forKey: .empty)

        var rawContent = try container.nestedUnkeyedContainer(forKey: .content)
        var decoded: [T] = []
        var rawCopy = rawContent
        while !rawContent.isAtEnd {
            if let rawValue = try? rawCopy.decode(AnyDecodable.self),
               let data = try? JSONSerialization.data(withJSONObject: rawValue.value),
               let element = try? JSONDecoder.pageDecoder.decode(T.self, from: data) {
                decoded.append(element)
            } else {
                _ = try? rawContent.decode(AnyDecodable.self)
            }
        }

        content = empty ? [] : decoded
    }

    private enum CodingKeys: String, CodingKey {
        case totalElements, totalPages, pageable, last, first
        case numberOfElements, size, content, number, sort, empty
    }
}

extension PageResponse {
    func toPaginationInfo() -> PaginationInfo {
        PaginationInfo(
            currentPage:   number,
            totalPages:    totalPages,
            totalElements: totalElements,
            isLast:        last
        )
    }
}

private struct AnyDecodable: Decodable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int    = try? container.decode(Int.self)    { value = int;    return }
        if let double = try? container.decode(Double.self) { value = double; return }
        if let bool   = try? container.decode(Bool.self)   { value = bool;   return }
        if let string = try? container.decode(String.self) { value = string; return }
        if let array  = try? container.decode([AnyDecodable].self) {
            value = array.map(\.value); return
        }
        if let dict   = try? container.decode([String: AnyDecodable].self) {
            value = dict.mapValues(\.value); return
        }
        value = [String: Any]()
    }
}

private extension JSONDecoder {
    static let pageDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
}
