{Model, Collection} = require 'exoskeleton'

util = require '../util'

class Permission extends Model
  modelKey: 'permission'

  getAvatarUrl: ->
    @get('principal')['avatar_url']

  getName: ->
    @get('principal')['name']

  getType: ->
    @get('principal')['type']

  getRole: ->
    @get 'role'

  isRead: ->
    @getRole() == 'READ'

  isEdit: ->
    @getRole() == 'EDIT'

  isAdmin: ->
    @getRole() == 'ADMIN'

  saveRole: (role) ->
    currentRole = @getRole()
    @save({role: role}, patch: true).catch (err) =>
      @set role: currentRole
      throw err

  setRead: ->
    @saveRole 'READ'

  setEdit: ->
    @saveRole 'EDIT'

  setAdmin: ->
    @saveRole 'ADMIN'

  destroy: ->
    collection = @collection
    super().catch (err) =>
      collection.add @
      throw err

class Permission.Collection extends Collection
  model: Permission

  initialize: (models, props) ->
    @url = "#{props.board.url()}/permissions"
    @rel =
      search: "#{props.board.url()}/permissions/search"

module.exports = Permission
