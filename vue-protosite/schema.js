import {merge, defaultsDeep} from 'lodash'

export const UISCHEMA_DEFAULTS = {
  default: {component: 'div'},
  string: {
    component: 'input',
    fieldOptions: {
      class: ['form-control'],
      on: ['input'],
      attrs: {
        type: 'text',
      },
    },
  },
  string_with_enum: {
    component: 'select',
    fieldOptions: {
      class: ['form-control'],
      on: ['input'],
    },
  },
  number: {
    component: 'input',
    fieldOptions: {
      class: ['form-control'],
      on: ['input'],
      attrs: {
        type: 'number',
      },
    },
  },
  integer: {
    component: 'input',
    fieldOptions: {
      class: ['form-control'],
      on: ['input'],
      attrs: {
        type: 'number',
      },
    },
  },
  boolean: {
    component: 'input',
    fieldOptions: {
      class: ['form-control'],
      on: ['input'],
      attrs: {
        type: 'checkbox',
      },
    },
  },
  object: {
    component: 'div',
    fieldOptions: {
      class: 'row',
    },
  },
  array: {
    component: 'div',
    fieldOptions: {
      class: 'row',
    },
  },
}

export class SchemaProcessor {
  constructor(defaults) {
    this.defaults = defaultsDeep({}, defaults, UISCHEMA_DEFAULTS)
  }

  process(schema) {
    if (schema.type !== 'object' || !schema.properties) return []
    if (schema.ui) return schema.ui

    let elements = []
    for (let [model, property] of Object.entries(schema.properties)) {
      elements.push(this.uiFor(model, property, this.process(property)))
    }

    return elements
  }

  uiFor(model, property = {}, children = null) {
    return merge({}, this.defaultsForType(property), property.ui, {
      model: model,
      children: children,
      fieldOptions: {
        attrs: property.attrs || {},
      },
    })
  }

  defaultsForType(property) {
    let types = []
    if (property.enum) types.push(`${property.type}_with_enum`)
    types.push(property.type)
    for (let type of types) {
      if (this.defaults[type]) return this.defaults[type]
    }
    return this.defaults['default']
  }
}
