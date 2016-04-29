/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
exports.schemaContributions = {
    schemaAssociations: {},
    schemas: {
        // bundle the schema-schema to include (localized) descriptions
        'http://json-schema.org/draft-04/schema#': {
            'title': localize(0, null),
            '$schema': 'http://json-schema.org/draft-04/schema#',
            'definitions': {
                'schemaArray': {
                    'type': 'array',
                    'minItems': 1,
                    'items': { '$ref': '#' }
                },
                'positiveInteger': {
                    'type': 'integer',
                    'minimum': 0
                },
                'positiveIntegerDefault0': {
                    'allOf': [{ '$ref': '#/definitions/positiveInteger' }, { 'default': 0 }]
                },
                'simpleTypes': {
                    'type': 'string',
                    'enum': ['array', 'boolean', 'integer', 'null', 'number', 'object', 'string']
                },
                'stringArray': {
                    'type': 'array',
                    'items': { 'type': 'string' },
                    'minItems': 1,
                    'uniqueItems': true
                }
            },
            'type': 'object',
            'properties': {
                'id': {
                    'type': 'string',
                    'format': 'uri',
                    'description': localize(1, null)
                },
                '$schema': {
                    'type': 'string',
                    'format': 'uri',
                    'description': localize(2, null)
                },
                'title': {
                    'type': 'string',
                    'description': localize(3, null)
                },
                'description': {
                    'type': 'string',
                    'description': localize(4, null)
                },
                'default': {
                    'description': localize(5, null)
                },
                'multipleOf': {
                    'type': 'number',
                    'minimum': 0,
                    'exclusiveMinimum': true,
                    'description': localize(6, null)
                },
                'maximum': {
                    'type': 'number',
                    'description': localize(7, null)
                },
                'exclusiveMaximum': {
                    'type': 'boolean',
                    'default': false,
                    'description': localize(8, null)
                },
                'minimum': {
                    'type': 'number',
                    'description': localize(9, null)
                },
                'exclusiveMinimum': {
                    'type': 'boolean',
                    'default': false,
                    'description': localize(10, null)
                },
                'maxLength': {
                    'allOf': [
                        { '$ref': '#/definitions/positiveInteger' }
                    ],
                    'description': localize(11, null)
                },
                'minLength': {
                    'allOf': [
                        { '$ref': '#/definitions/positiveIntegerDefault0' }
                    ],
                    'description': localize(12, null)
                },
                'pattern': {
                    'type': 'string',
                    'format': 'regex',
                    'description': localize(13, null)
                },
                'additionalItems': {
                    'anyOf': [
                        { 'type': 'boolean' },
                        { '$ref': '#' }
                    ],
                    'default': {},
                    'description': localize(14, null)
                },
                'items': {
                    'anyOf': [
                        { '$ref': '#' },
                        { '$ref': '#/definitions/schemaArray' }
                    ],
                    'default': {},
                    'description': localize(15, null)
                },
                'maxItems': {
                    'allOf': [
                        { '$ref': '#/definitions/positiveInteger' }
                    ],
                    'description': localize(16, null)
                },
                'minItems': {
                    'allOf': [
                        { '$ref': '#/definitions/positiveIntegerDefault0' }
                    ],
                    'description': localize(17, null)
                },
                'uniqueItems': {
                    'type': 'boolean',
                    'default': false,
                    'description': localize(18, null)
                },
                'maxProperties': {
                    'allOf': [
                        { '$ref': '#/definitions/positiveInteger' }
                    ],
                    'description': localize(19, null)
                },
                'minProperties': {
                    'allOf': [
                        { '$ref': '#/definitions/positiveIntegerDefault0' },
                    ],
                    'description': localize(20, null)
                },
                'required': {
                    'allOf': [
                        { '$ref': '#/definitions/stringArray' }
                    ],
                    'description': localize(21, null)
                },
                'additionalProperties': {
                    'anyOf': [
                        { 'type': 'boolean' },
                        { '$ref': '#' }
                    ],
                    'default': {},
                    'description': localize(22, null)
                },
                'definitions': {
                    'type': 'object',
                    'additionalProperties': { '$ref': '#' },
                    'default': {},
                    'description': localize(23, null)
                },
                'properties': {
                    'type': 'object',
                    'additionalProperties': { '$ref': '#' },
                    'default': {},
                    'description': localize(24, null)
                },
                'patternProperties': {
                    'type': 'object',
                    'additionalProperties': { '$ref': '#' },
                    'default': {},
                    'description': localize(25, null)
                },
                'dependencies': {
                    'type': 'object',
                    'additionalProperties': {
                        'anyOf': [
                            { '$ref': '#' },
                            { '$ref': '#/definitions/stringArray' }
                        ]
                    },
                    'description': localize(26, null)
                },
                'enum': {
                    'type': 'array',
                    'minItems': 1,
                    'uniqueItems': true,
                    'description': localize(27, null)
                },
                'type': {
                    'anyOf': [
                        { '$ref': '#/definitions/simpleTypes' },
                        {
                            'type': 'array',
                            'items': { '$ref': '#/definitions/simpleTypes' },
                            'minItems': 1,
                            'uniqueItems': true
                        }
                    ],
                    'description': localize(28, null)
                },
                'format': {
                    'anyOf': [
                        {
                            'type': 'string',
                            'description': localize(29, null),
                            'enum': ['date-time', 'uri', 'email', 'hostname', 'ipv4', 'ipv6', 'regex']
                        }, {
                            'type': 'string'
                        }
                    ]
                },
                'allOf': {
                    'allOf': [
                        { '$ref': '#/definitions/schemaArray' }
                    ],
                    'description': localize(30, null)
                },
                'anyOf': {
                    'allOf': [
                        { '$ref': '#/definitions/schemaArray' }
                    ],
                    'description': localize(31, null)
                },
                'oneOf': {
                    'allOf': [
                        { '$ref': '#/definitions/schemaArray' }
                    ],
                    'description': localize(32, null)
                },
                'not': {
                    'allOf': [
                        { '$ref': '#' }
                    ],
                    'description': localize(33, null)
                }
            },
            'dependencies': {
                'exclusiveMaximum': ['maximum'],
                'exclusiveMinimum': ['minimum']
            },
            'default': {}
        }
    }
};
//# sourceMappingURL=configuration.js.map