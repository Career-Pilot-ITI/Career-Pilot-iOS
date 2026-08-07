import Foundation

struct PaginationInfo: Equatable {
    let currentPage: Int
    let totalPages: Int
    let totalElements: Int
    let isLast: Bool

    var hasMore: Bool { !isLast }
}
