import Foundation

struct PaginatedResult<T> {
    let items: [T]
    let pagination: PaginationInfo
}
