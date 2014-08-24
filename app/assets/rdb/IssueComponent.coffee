core = require 'rui/core'
{div, header, section, a, p} = require 'rui/DOM'

BackboneMixins = require 'rdb/BackboneMixins'

module.exports = core.createComponent 'rdb.IssueComponent',
  mixins: [BackboneMixins.ModelView]

  render: ->
    div className: 'rdb-issue', [
      div className: 'rdb-issue-inlet', [
        header [
          a [ @props.model.get 'name' ]
        ]
        section [
          p [ @props.model.get 'subject' ]
        ]
      ]
    ]
