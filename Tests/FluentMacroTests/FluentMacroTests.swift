import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(FluentMacroMacros)
    import FluentMacroMacros

    let testMacros: [String: Macro.Type] = [
        "FluentFiltering": FluentFilteringMacro.self,
        "FluentFilteringField": FluentFilteringFieldMacro.self
    ]
#endif

final class FluentMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(FluentMacroMacros)
            assertMacroExpansion(
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
                    var gameVersion: String?
                    var createdAt: Date?
                    var updatedAt: Date?
                    var deletedAt: Date?
                }

                """,
                expandedSource: """
                final class SimulatorModel: @unchecked Sendable {
                    static let schema = "simulators"

                    var id: UUID?
                    var intID: Int
                    var locationID: UUID
                    var position: String
                    var positions: [String]
                    var gameVersion: String?
                    var createdAt: Date?
                    var updatedAt: Date?
                    var deletedAt: Date?
                }

                extension SimulatorModel {
                    struct Filter: Codable, Hashable {
                        var intIDEQ: Int?
                        var intIDNEQ: Int?
                        var intIDGT: Int?
                        var intIDGTE: Int?
                        var intIDLT: Int?
                        var intIDLTE: Int?
                        var locationIDEQ: UUID?
                        var locationIDNEQ: UUID?
                        var locationIDGT: UUID?
                        var locationIDGTE: UUID?
                        var locationIDLT: UUID?
                        var locationIDLTE: UUID?
                        var positionILIKE: String?
                        var positionsVS: [String]?
                        var positionsNVS: [String]?
                    }
                }

                extension QueryBuilder where Model == SimulatorModel {
                    func filter(with args: SimulatorModel.Filter) -> Self {
                        var query = self

                        if let intIDEQ = args.intIDEQ {
                            query.filter(\\.$intID == intIDEQ)
                        }
                        if let intIDNEQ = args.intIDNEQ {
                            query.filter(\\.$intID != intIDNEQ)
                        }
                        if let intIDGT = args.intIDGT {
                            query.filter(\\.$intID > intIDGT)
                        }
                        if let intIDGTE = args.intIDGTE {
                            query.filter(\\.$intID >= intIDGTE)
                        }
                        if let intIDLT = args.intIDLT {
                            query.filter(\\.$intID < intIDLT)
                        }
                        if let intIDLTE = args.intIDLTE {
                            query.filter(\\.$intID <= intIDLTE)
                        }
                        if let locationIDEQ = args.locationIDEQ {
                            query.filter(\\.$locationID == locationIDEQ)
                        }
                        if let locationIDNEQ = args.locationIDNEQ {
                            query.filter(\\.$locationID != locationIDNEQ)
                        }
                        if let locationIDGT = args.locationIDGT {
                            query.filter(\\.$locationID > locationIDGT)
                        }
                        if let locationIDGTE = args.locationIDGTE {
                            query.filter(\\.$locationID >= locationIDGTE)
                        }
                        if let locationIDLT = args.locationIDLT {
                            query.filter(\\.$locationID < locationIDLT)
                        }
                        if let locationIDLTE = args.locationIDLTE {
                            query.filter(\\.$locationID <= locationIDLTE)
                        }
                        if let positionILIKE = args.positionILIKE {
                            query.filter(\\.$position, .custom("ILIKE"), "%\\(positionILIKE)%")
                        }
                        if let positionsVS = args.positionsVS {
                            query.filter(\\.$positions ~~ positionsVS)
                        }
                        if let positionsNVS = args.positionsNVS {
                            query.filter(\\.$positions !~ positionsNVS)
                        }

                        return query
                    }
                }
                """,
                macros: testMacros
            )
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
