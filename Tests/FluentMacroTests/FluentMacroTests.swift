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
            final class TestModel: @unchecked Sendable {
                static let schema = "test"

                var id: UUID?
                @FluentSortingField
                var intField: Int
                @FluentSortingField
                var uuidField: UUID
                @FluentSortingField
                var stringField: String
                @FluentSortingField
                var arrayField: [String]
                @Group(key: .position)
                var groupField: TestGroup
                @FluentSortingField
                var dateField: Date
                @FluentSortingField
                var optionalDateField: Date?
                
                init() {}

                final class TestGroup {
                    @FluentSortingField
                    var intField: Int
                    @FluentSortingField
                    var uuidField: UUID
                    @FluentSortingField
                    var stringField: String
                    @FluentSortingField
                    var arrayField: [String]
                    @FluentSortingField
                    var dateField: Date
                    @FluentSortingField
                    var optionalDateField: Date?
                    
                    init() {}
                }
            }
            """
        } expansion: {
            #"""
            final class TestModel: @unchecked Sendable {
                static let schema = "test"

                var id: UUID?
                var intField: Int
                var uuidField: UUID
                var stringField: String
                var arrayField: [String]
                @Group(key: .position)
                var groupField: TestGroup
                var dateField: Date
                var optionalDateField: Date?
                
                init() {}

                final class TestGroup {
                    var intField: Int
                    var uuidField: UUID
                    var stringField: String
                    var arrayField: [String]
                    var dateField: Date
                    var optionalDateField: Date?
                    
                    init() {}
                }
            }

            extension TestModel {
                enum Sort: String, Codable, CaseIterable {
                    case intField
                    case uuidField
                    case stringField
                    case arrayField
                    case intField
                    case uuidField
                    case stringField
                    case arrayField
                    case dateField
                    case optionalDateField
                    case dateField
                    case optionalDateField
                }
            }

            extension QueryBuilder where Model == TestModel {
                func sort(fields: [TestModel.Sort: DatabaseQuery.Sort.Direction]) -> Self {
                    var query = self
                    fields.forEach { field in
                        switch field {
                        case .intField:
                            query = query.sort(\.$intField, direction)
                        case .uuidField:
                            query = query.sort(\.$uuidField, direction)
                        case .stringField:
                            query = query.sort(\.$stringField, direction)
                        case .arrayField:
                            query = query.sort(\.$arrayField, direction)
                        case .intField:
                            query = query.sort(\.$groupField.$intField, direction)
                        case .uuidField:
                            query = query.sort(\.$groupField.$uuidField, direction)
                        case .stringField:
                            query = query.sort(\.$groupField.$stringField, direction)
                        case .arrayField:
                            query = query.sort(\.$groupField.$arrayField, direction)
                        case .dateField:
                            query = query.sort(\.$groupField.$dateField, direction)
                        case .optionalDateField:
                            query = query.sort(\.$groupField.$optionalDateField, direction)
                        case .dateField:
                            query = query.sort(\.$dateField, direction)
                        case .optionalDateField:
                            query = query.sort(\.$optionalDateField, direction)
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
            final class TestModel: @unchecked Sendable {
                static let schema = "test"

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
                var intField: Int
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
                var uuidField: UUID
                @FluentFilteringField(
                    methods: [
                        .ilike,
                        .valueInSet,
                        .valueNotInSet
                    ]
                )
                var stringField: String
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
                var arrayField: [String]
                @Group(key: .position)
                var groupField: TestGroup
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
                var dateField: Date
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
                var optionalDateField: Date?
                
                init() {}

                final class TestGroup {
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
                    var intField: Int
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
                    var uuidField: UUID
                    @FluentFilteringField(
                        methods: [
                            .ilike,
                            .valueInSet,
                            .valueNotInSet
                        ]
                    )
                    var stringField: String
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
                    var arrayField: [String]
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
                    var dateField: Date
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
                    var optionalDateField: Date?
                    
                    init() {}
                }
            }
            """
        } expansion: {
            #"""
            final class TestModel: @unchecked Sendable {
                static let schema = "test"

                var id: UUID?
                var intField: Int
                var uuidField: UUID
                var stringField: String
                var arrayField: [String]
                @Group(key: .position)
                var groupField: TestGroup
                var dateField: Date
                var optionalDateField: Date?
                
                init() {}

                final class TestGroup {
                    var intField: Int
                    var uuidField: UUID
                    var stringField: String
                    var arrayField: [String]
                    var dateField: Date
                    var optionalDateField: Date?
                    
                    init() {}
                }
            }

            extension TestModel {
                struct Filter: Codable, Hashable {
                    var intFieldEQ: Int?
                    var intFieldNEQ: Int?
                    var intFieldGT: Int?
                    var intFieldGTE: Int?
                    var intFieldLT: Int?
                    var intFieldLTE: Int?
                    var uuidFieldEQ: UUID?
                    var uuidFieldNEQ: UUID?
                    var uuidFieldGT: UUID?
                    var uuidFieldGTE: UUID?
                    var uuidFieldLT: UUID?
                    var uuidFieldLTE: UUID?
                    var stringFieldILIKE: String?
                    var stringFieldVS: [String]?
                    var stringFieldNVS: [String]?
                    var arrayFieldEQ: String?
                    var arrayFieldNEQ: String?
                    var arrayFieldGT: String?
                    var arrayFieldGTE: String?
                    var arrayFieldLT: String?
                    var arrayFieldLTE: String?
                    var intFieldEQ: Int?
                    var intFieldNEQ: Int?
                    var intFieldGT: Int?
                    var intFieldGTE: Int?
                    var intFieldLT: Int?
                    var intFieldLTE: Int?
                    var uuidFieldEQ: UUID?
                    var uuidFieldNEQ: UUID?
                    var uuidFieldGT: UUID?
                    var uuidFieldGTE: UUID?
                    var uuidFieldLT: UUID?
                    var uuidFieldLTE: UUID?
                    var stringFieldILIKE: String?
                    var stringFieldVS: [String]?
                    var stringFieldNVS: [String]?
                    var arrayFieldEQ: String?
                    var arrayFieldNEQ: String?
                    var arrayFieldGT: String?
                    var arrayFieldGTE: String?
                    var arrayFieldLT: String?
                    var arrayFieldLTE: String?
                    var dateFieldEQ: Date?
                    var dateFieldNEQ: Date?
                    var dateFieldGT: Date?
                    var dateFieldGTE: Date?
                    var dateFieldLT: Date?
                    var dateFieldLTE: Date?
                    var optionalDateFieldEQ: Date?
                    var optionalDateFieldNEQ: Date?
                    var optionalDateFieldGT: Date?
                    var optionalDateFieldGTE: Date?
                    var optionalDateFieldLT: Date?
                    var optionalDateFieldLTE: Date?
                    var dateFieldEQ: Date?
                    var dateFieldNEQ: Date?
                    var dateFieldGT: Date?
                    var dateFieldGTE: Date?
                    var dateFieldLT: Date?
                    var dateFieldLTE: Date?
                    var optionalDateFieldEQ: Date?
                    var optionalDateFieldNEQ: Date?
                    var optionalDateFieldGT: Date?
                    var optionalDateFieldGTE: Date?
                    var optionalDateFieldLT: Date?
                    var optionalDateFieldLTE: Date?
                }
            }

            extension QueryBuilder where Model == TestModel {
                func filter(with args: TestModel.Filter) -> Self {
                    var query = self

                    if let intFieldEQ = args.intFieldEQ {
                        query.filter(\.$intField == intFieldEQ)
                    }
                    if let intFieldNEQ = args.intFieldNEQ {
                        query.filter(\.$intField != intFieldNEQ)
                    }
                    if let intFieldGT = args.intFieldGT {
                        query.filter(\.$intField > intFieldGT)
                    }
                    if let intFieldGTE = args.intFieldGTE {
                        query.filter(\.$intField >= intFieldGTE)
                    }
                    if let intFieldLT = args.intFieldLT {
                        query.filter(\.$intField < intFieldLT)
                    }
                    if let intFieldLTE = args.intFieldLTE {
                        query.filter(\.$intField <= intFieldLTE)
                    }
                    if let uuidFieldEQ = args.uuidFieldEQ {
                        query.filter(\.$uuidField == uuidFieldEQ)
                    }
                    if let uuidFieldNEQ = args.uuidFieldNEQ {
                        query.filter(\.$uuidField != uuidFieldNEQ)
                    }
                    if let uuidFieldGT = args.uuidFieldGT {
                        query.filter(\.$uuidField > uuidFieldGT)
                    }
                    if let uuidFieldGTE = args.uuidFieldGTE {
                        query.filter(\.$uuidField >= uuidFieldGTE)
                    }
                    if let uuidFieldLT = args.uuidFieldLT {
                        query.filter(\.$uuidField < uuidFieldLT)
                    }
                    if let uuidFieldLTE = args.uuidFieldLTE {
                        query.filter(\.$uuidField <= uuidFieldLTE)
                    }
                    if let stringFieldILIKE = args.stringFieldILIKE {
                        query.filter(\.$stringField, .custom("ILIKE"), "%\(stringFieldILIKE)%")
                    }
                    if let stringFieldVS = args.stringFieldVS {
                        query.filter(\.$stringField ~~ stringFieldVS)
                    }
                    if let stringFieldNVS = args.stringFieldNVS {
                        query.filter(\.$stringField !~ stringFieldNVS)
                    }
                    if let arrayFieldEQ = args.arrayFieldEQ {
                        query.filter(\.$arrayField == arrayFieldEQ)
                    }
                    if let arrayFieldNEQ = args.arrayFieldNEQ {
                        query.filter(\.$arrayField != arrayFieldNEQ)
                    }
                    if let arrayFieldGT = args.arrayFieldGT {
                        query.filter(\.$arrayField > arrayFieldGT)
                    }
                    if let arrayFieldGTE = args.arrayFieldGTE {
                        query.filter(\.$arrayField >= arrayFieldGTE)
                    }
                    if let arrayFieldLT = args.arrayFieldLT {
                        query.filter(\.$arrayField < arrayFieldLT)
                    }
                    if let arrayFieldLTE = args.arrayFieldLTE {
                        query.filter(\.$arrayField <= arrayFieldLTE)
                    }
                    if let intFieldEQ = args.intFieldEQ {
                        query.filter(\.$groupField.$intField == intFieldEQ)
                    }
                    if let intFieldNEQ = args.intFieldNEQ {
                        query.filter(\.$groupField.$intField != intFieldNEQ)
                    }
                    if let intFieldGT = args.intFieldGT {
                        query.filter(\.$groupField.$intField > intFieldGT)
                    }
                    if let intFieldGTE = args.intFieldGTE {
                        query.filter(\.$groupField.$intField >= intFieldGTE)
                    }
                    if let intFieldLT = args.intFieldLT {
                        query.filter(\.$groupField.$intField < intFieldLT)
                    }
                    if let intFieldLTE = args.intFieldLTE {
                        query.filter(\.$groupField.$intField <= intFieldLTE)
                    }
                    if let uuidFieldEQ = args.uuidFieldEQ {
                        query.filter(\.$groupField.$uuidField == uuidFieldEQ)
                    }
                    if let uuidFieldNEQ = args.uuidFieldNEQ {
                        query.filter(\.$groupField.$uuidField != uuidFieldNEQ)
                    }
                    if let uuidFieldGT = args.uuidFieldGT {
                        query.filter(\.$groupField.$uuidField > uuidFieldGT)
                    }
                    if let uuidFieldGTE = args.uuidFieldGTE {
                        query.filter(\.$groupField.$uuidField >= uuidFieldGTE)
                    }
                    if let uuidFieldLT = args.uuidFieldLT {
                        query.filter(\.$groupField.$uuidField < uuidFieldLT)
                    }
                    if let uuidFieldLTE = args.uuidFieldLTE {
                        query.filter(\.$groupField.$uuidField <= uuidFieldLTE)
                    }
                    if let stringFieldILIKE = args.stringFieldILIKE {
                        query.filter(\.$groupField.$stringField, .custom("ILIKE"), "%\(stringFieldILIKE)%")
                    }
                    if let stringFieldVS = args.stringFieldVS {
                        query.filter(\.$groupField.$stringField ~~ stringFieldVS)
                    }
                    if let stringFieldNVS = args.stringFieldNVS {
                        query.filter(\.$groupField.$stringField !~ stringFieldNVS)
                    }
                    if let arrayFieldEQ = args.arrayFieldEQ {
                        query.filter(\.$groupField.$arrayField == arrayFieldEQ)
                    }
                    if let arrayFieldNEQ = args.arrayFieldNEQ {
                        query.filter(\.$groupField.$arrayField != arrayFieldNEQ)
                    }
                    if let arrayFieldGT = args.arrayFieldGT {
                        query.filter(\.$groupField.$arrayField > arrayFieldGT)
                    }
                    if let arrayFieldGTE = args.arrayFieldGTE {
                        query.filter(\.$groupField.$arrayField >= arrayFieldGTE)
                    }
                    if let arrayFieldLT = args.arrayFieldLT {
                        query.filter(\.$groupField.$arrayField < arrayFieldLT)
                    }
                    if let arrayFieldLTE = args.arrayFieldLTE {
                        query.filter(\.$groupField.$arrayField <= arrayFieldLTE)
                    }
                    if let dateFieldEQ = args.dateFieldEQ {
                        query.filter(\.$groupField.$dateField == dateFieldEQ)
                    }
                    if let dateFieldNEQ = args.dateFieldNEQ {
                        query.filter(\.$groupField.$dateField != dateFieldNEQ)
                    }
                    if let dateFieldGT = args.dateFieldGT {
                        query.filter(\.$groupField.$dateField > dateFieldGT)
                    }
                    if let dateFieldGTE = args.dateFieldGTE {
                        query.filter(\.$groupField.$dateField >= dateFieldGTE)
                    }
                    if let dateFieldLT = args.dateFieldLT {
                        query.filter(\.$groupField.$dateField < dateFieldLT)
                    }
                    if let dateFieldLTE = args.dateFieldLTE {
                        query.filter(\.$groupField.$dateField <= dateFieldLTE)
                    }
                    if let optionalDateFieldEQ = args.optionalDateFieldEQ {
                        query.filter(\.$groupField.$optionalDateField == optionalDateFieldEQ)
                    }
                    if let optionalDateFieldNEQ = args.optionalDateFieldNEQ {
                        query.filter(\.$groupField.$optionalDateField != optionalDateFieldNEQ)
                    }
                    if let optionalDateFieldGT = args.optionalDateFieldGT {
                        query.filter(\.$groupField.$optionalDateField > optionalDateFieldGT)
                    }
                    if let optionalDateFieldGTE = args.optionalDateFieldGTE {
                        query.filter(\.$groupField.$optionalDateField >= optionalDateFieldGTE)
                    }
                    if let optionalDateFieldLT = args.optionalDateFieldLT {
                        query.filter(\.$groupField.$optionalDateField < optionalDateFieldLT)
                    }
                    if let optionalDateFieldLTE = args.optionalDateFieldLTE {
                        query.filter(\.$groupField.$optionalDateField <= optionalDateFieldLTE)
                    }
                    if let dateFieldEQ = args.dateFieldEQ {
                        query.filter(\.$dateField == dateFieldEQ)
                    }
                    if let dateFieldNEQ = args.dateFieldNEQ {
                        query.filter(\.$dateField != dateFieldNEQ)
                    }
                    if let dateFieldGT = args.dateFieldGT {
                        query.filter(\.$dateField > dateFieldGT)
                    }
                    if let dateFieldGTE = args.dateFieldGTE {
                        query.filter(\.$dateField >= dateFieldGTE)
                    }
                    if let dateFieldLT = args.dateFieldLT {
                        query.filter(\.$dateField < dateFieldLT)
                    }
                    if let dateFieldLTE = args.dateFieldLTE {
                        query.filter(\.$dateField <= dateFieldLTE)
                    }
                    if let optionalDateFieldEQ = args.optionalDateFieldEQ {
                        query.filter(\.$optionalDateField == optionalDateFieldEQ)
                    }
                    if let optionalDateFieldNEQ = args.optionalDateFieldNEQ {
                        query.filter(\.$optionalDateField != optionalDateFieldNEQ)
                    }
                    if let optionalDateFieldGT = args.optionalDateFieldGT {
                        query.filter(\.$optionalDateField > optionalDateFieldGT)
                    }
                    if let optionalDateFieldGTE = args.optionalDateFieldGTE {
                        query.filter(\.$optionalDateField >= optionalDateFieldGTE)
                    }
                    if let optionalDateFieldLT = args.optionalDateFieldLT {
                        query.filter(\.$optionalDateField < optionalDateFieldLT)
                    }
                    if let optionalDateFieldLTE = args.optionalDateFieldLTE {
                        query.filter(\.$optionalDateField <= optionalDateFieldLTE)
                    }

                    return query
                }
            }
            """#
        }
    }
}
