//import FluentMacro
//import Foundation
//
//@FluentSorting
//@FluentFiltering
//final class SimulatorModel: @unchecked Sendable {
//    static let schema = "simulators"
//
//    var id: UUID?
//
//    @FluentSortingField
//    @FluentFilteringField(
//        methods: [
//            .equal,
//            .notEqual,
//            .greaterThan,
//            .greaterThanOrEqual,
//            .lessThan,
//            .lessThanOrEqual
//        ]
//    )
//    var intID: Int
//
//    @FluentSortingField
//    var locationID: UUID
//
//    @FluentSortingField
//    @FluentFilteringField(
//        methods: [
//            .ilike
//        ]
//    )
//    var position: String
//
//    @FluentFilteringField(
//        methods: [
//            .valueInSet,
//            .valueNotInSet
//        ]
//    )
//    var positions: [String]
//
//    @Group(key: .position)
//    var positionen: SimulatorPosition
//
//    var gameVersion: String?
//    @FluentSortingField
//    var createdAt: Date?
//    var updatedAt: Date?
//    var deletedAt: Date?
//
//    init(id: UUID?, intID: Int, locationID: UUID, position: String, gameVersion: String?, createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
//        self.id = id
//        self.intID = intID
//        self.locationID = locationID
//        self.position = position
//        self.gameVersion = gameVersion
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
//        self.deletedAt = deletedAt
//    }
//
//    final class SimulatorPosition {
//        @FluentFilteringField(
//            methods: [
//                .equal,
//                .notEqual,
//                .greaterThan,
//                .greaterThanOrEqual,
//                .lessThan,
//                .lessThanOrEqual,
//            ]
//        )
//        @FluentSortingField
//        var coordinateX: Int?
//        @FluentFilteringField(
//            methods: [
//                .equal,
//                .notEqual,
//                .greaterThan,
//                .greaterThanOrEqual,
//                .lessThan,
//                .lessThanOrEqual,
//            ]
//        )
//        @FluentSortingField
//        var coordinateY: Int?
//
//        internal init() {}
//
//        internal init(
//            coordinateX: Int? = nil,
//            coordinateY: Int? = nil
//        ) {
//            self.coordinateX = coordinateX
//            self.coordinateY = coordinateY
//        }
//    }
//}
