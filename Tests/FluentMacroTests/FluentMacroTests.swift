import FluentMacroMacros
import MacroTesting
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@Suite(
    .macros(
        record: .missing,
        macros: [
            "FluentSorting": FluentSortingMacro.self,
            "FluentFiltering": FluentFilteringMacro.self,
            "FluentSortingField": FluentSortingFieldMacro.self,
            "FluentFilteringField": FluentFilteringFieldMacro.self,
        ]
    )
)

struct FluentMacroTests {
    @Test
    func testSortingMacro() {
        assertMacro {
            """
            @FluentSorting
            final class SimulatorModel: @unchecked Sendable {
                static let schema = "simulators"

                var id: UUID?
                @FluentSortingField
                var intID: Int
                @FluentSortingField
                var locationID: UUID
                @FluentSortingField
                var position: String
                var positions: [String]
                @Group(key: .position)
                var positionen: SimulatorPosition
                var gameVersion: String?
                @FluentSortingField
                var createdAt: Date?
                var updatedAt: Date?
                var deletedAt: Date?

                init(id: UUID?, intID: Int, locationID: UUID, position: String, gameVersion: String?, createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
                    self.id = id
                    self.intID = intID
                    self.locationID = locationID
                    self.position = position
                    self.gameVersion = gameVersion
                    self.createdAt = createdAt
                    self.updatedAt = updatedAt
                    self.deletedAt = deletedAt
                }

                final class SimulatorPosition {
                    @FluentSortingField
                    var coordinateX: Int?
                    @FluentSortingField
                    var coordinateY: Int?

                    internal init() {}

                    internal init(
                        coordinateX: Int? = nil,
                        coordinateY: Int? = nil
                    ) {
                        self.coordinateX = coordinateX
                        self.coordinateY = coordinateY
                    }
                }
            }
            """
        } expansion: {
            #"""
            final class SimulatorModel: @unchecked Sendable {
                static let schema = "simulators"

                var id: UUID?
                var intID: Int
                var locationID: UUID
                var position: String
                var positions: [String]
                @Group(key: .position)
                var positionen: SimulatorPosition
                var gameVersion: String?
                var createdAt: Date?
                var updatedAt: Date?
                var deletedAt: Date?

                init(id: UUID?, intID: Int, locationID: UUID, position: String, gameVersion: String?, createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
                    self.id = id
                    self.intID = intID
                    self.locationID = locationID
                    self.position = position
                    self.gameVersion = gameVersion
                    self.createdAt = createdAt
                    self.updatedAt = updatedAt
                    self.deletedAt = deletedAt
                }

                final class SimulatorPosition {
                    var coordinateX: Int?
                    var coordinateY: Int?

                    internal init() {}

                    internal init(
                        coordinateX: Int? = nil,
                        coordinateY: Int? = nil
                    ) {
                        self.coordinateX = coordinateX
                        self.coordinateY = coordinateY
                    }
                }
            }

            extension SimulatorModel {
                enum Sort: String, Codable, CaseIterable {
                    case intID
                    case locationID
                    case position
                    case coordinateX
                    case coordinateY
                    case createdAt
                }
            }

            extension QueryBuilder where Model == SimulatorModel {
                func sort(fields: [SimulatorModel.Sort: DatabaseQuery.Sort.Direction]) -> Self {
                    var query = self
                    fields.forEach { field in
                        switch field {
                        case .intID:
                            query = query.sort(\.$intID, direction)
                        case .locationID:
                            query = query.sort(\.$locationID, direction)
                        case .position:
                            query = query.sort(\.$position, direction)
                        case .coordinateX:
                            query = query.sort(\.$positionen.$coordinateX, direction)
                        case .coordinateY:
                            query = query.sort(\.$positionen.$coordinateY, direction)
                        case .createdAt:
                            query = query.sort(\.$createdAt, direction)
                        }
                    }
                    return query
                }
            }
            """#
        }
    }

    @Test
    func testFilteringMacro() throws {
        assertMacro {
            """
            @FluentFiltering
            final class SimulatorModel: @unchecked Sendable {
                static let schema = "simulators"

                var id: UUID?
                @FluentFilteringField(
                    methods: [
                        .equal,
                        .notEqual,
                        .greaterThan,
                        .greaterThanOrEqual,
                        .lessThan,
                        .lessThanOrEqual,
                    ]
                )
                var intID: Int
                var locationID: UUID
                @FluentFilteringField(
                    methods: [
                        .ilike
                    ]
                )
                var position: String
                @FluentFilteringField(
                    methods: [
                        .valueInSet,
                        .valueNotInSet
                    ]
                )
                var positions: [String]
                @Group(key: .position)
                var positionen: SimulatorPosition
                var gameVersion: String?
                var createdAt: Date?
                var updatedAt: Date?
                var deletedAt: Date?

                init(id: UUID?, intID: Int, locationID: UUID, position: String, gameVersion: String?, createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
                    self.id = id
                    self.intID = intID
                    self.locationID = locationID
                    self.position = position
                    self.gameVersion = gameVersion
                    self.createdAt = createdAt
                    self.updatedAt = updatedAt
                    self.deletedAt = deletedAt
                }

                final class SimulatorPosition {
                    @FluentFilteringField(
                        methods: [
                            .equal,
                            .notEqual,
                            .greaterThan,
                            .greaterThanOrEqual,
                            .lessThan,
                            .lessThanOrEqual,
                        ]
                    )
                    var coordinateX: Int?
                    @FluentFilteringField(
                        methods: [
                            .equal,
                            .notEqual,
                            .greaterThan,
                            .greaterThanOrEqual,
                            .lessThan,
                            .lessThanOrEqual,
                        ]
                    )
                    var coordinateY: Int?

                    internal init() {}

                    internal init(
                        coordinateX: Int? = nil,
                        coordinateY: Int? = nil
                    ) {
                        self.coordinateX = coordinateX
                        self.coordinateY = coordinateY
                    }
                }
            }
            """
        } expansion: {
            #"""
            final class SimulatorModel: @unchecked Sendable {
                static let schema = "simulators"

                var id: UUID?
                var intID: Int
                var locationID: UUID
                var position: String
                var positions: [String]
                @Group(key: .position)
                var positionen: SimulatorPosition
                var gameVersion: String?
                var createdAt: Date?
                var updatedAt: Date?
                var deletedAt: Date?

                init(id: UUID?, intID: Int, locationID: UUID, position: String, gameVersion: String?, createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
                    self.id = id
                    self.intID = intID
                    self.locationID = locationID
                    self.position = position
                    self.gameVersion = gameVersion
                    self.createdAt = createdAt
                    self.updatedAt = updatedAt
                    self.deletedAt = deletedAt
                }

                final class SimulatorPosition {
                    var coordinateX: Int?
                    var coordinateY: Int?

                    internal init() {}

                    internal init(
                        coordinateX: Int? = nil,
                        coordinateY: Int? = nil
                    ) {
                        self.coordinateX = coordinateX
                        self.coordinateY = coordinateY
                    }
                }
            }

            extension SimulatorModel {
                struct Filter: Codable, Hashable {
                    var intIDEQ: Int?
                    var intIDNEQ: Int?
                    var intIDGT: Int?
                    var intIDGTE: Int?
                    var intIDLT: Int?
                    var intIDLTE: Int?
                    var positionILIKE: String?
                    var positionsVS: [String]?
                    var positionsNVS: [String]?
                    var coordinateXEQ: Int?
                    var coordinateXNEQ: Int?
                    var coordinateXGT: Int?
                    var coordinateXGTE: Int?
                    var coordinateXLT: Int?
                    var coordinateXLTE: Int?
                    var coordinateYEQ: Int?
                    var coordinateYNEQ: Int?
                    var coordinateYGT: Int?
                    var coordinateYGTE: Int?
                    var coordinateYLT: Int?
                    var coordinateYLTE: Int?
                }
            }

            extension QueryBuilder where Model == SimulatorModel {
                func filter(with args: SimulatorModel.Filter) -> Self {
                    var query = self

                    if let intIDEQ = args.intIDEQ {
                        query.filter(\.$intID == intIDEQ)
                    }
                    if let intIDNEQ = args.intIDNEQ {
                        query.filter(\.$intID != intIDNEQ)
                    }
                    if let intIDGT = args.intIDGT {
                        query.filter(\.$intID > intIDGT)
                    }
                    if let intIDGTE = args.intIDGTE {
                        query.filter(\.$intID >= intIDGTE)
                    }
                    if let intIDLT = args.intIDLT {
                        query.filter(\.$intID < intIDLT)
                    }
                    if let intIDLTE = args.intIDLTE {
                        query.filter(\.$intID <= intIDLTE)
                    }
                    if let positionILIKE = args.positionILIKE {
                        query.filter(\.$position, .custom("ILIKE"), "%\(positionILIKE)%")
                    }
                    if let positionsVS = args.positionsVS {
                        query.filter(\.$positions ~~ positionsVS)
                    }
                    if let positionsNVS = args.positionsNVS {
                        query.filter(\.$positions !~ positionsNVS)
                    }
                    if let coordinateXEQ = args.coordinateXEQ {
                        query.filter(\.$positionen.$coordinateX == coordinateXEQ)
                    }
                    if let coordinateXNEQ = args.coordinateXNEQ {
                        query.filter(\.$positionen.$coordinateX != coordinateXNEQ)
                    }
                    if let coordinateXGT = args.coordinateXGT {
                        query.filter(\.$positionen.$coordinateX > coordinateXGT)
                    }
                    if let coordinateXGTE = args.coordinateXGTE {
                        query.filter(\.$positionen.$coordinateX >= coordinateXGTE)
                    }
                    if let coordinateXLT = args.coordinateXLT {
                        query.filter(\.$positionen.$coordinateX < coordinateXLT)
                    }
                    if let coordinateXLTE = args.coordinateXLTE {
                        query.filter(\.$positionen.$coordinateX <= coordinateXLTE)
                    }
                    if let coordinateYEQ = args.coordinateYEQ {
                        query.filter(\.$positionen.$coordinateY == coordinateYEQ)
                    }
                    if let coordinateYNEQ = args.coordinateYNEQ {
                        query.filter(\.$positionen.$coordinateY != coordinateYNEQ)
                    }
                    if let coordinateYGT = args.coordinateYGT {
                        query.filter(\.$positionen.$coordinateY > coordinateYGT)
                    }
                    if let coordinateYGTE = args.coordinateYGTE {
                        query.filter(\.$positionen.$coordinateY >= coordinateYGTE)
                    }
                    if let coordinateYLT = args.coordinateYLT {
                        query.filter(\.$positionen.$coordinateY < coordinateYLT)
                    }
                    if let coordinateYLTE = args.coordinateYLTE {
                        query.filter(\.$positionen.$coordinateY <= coordinateYLTE)
                    }

                    return query
                }
            }
            """#
        }
    }
}
