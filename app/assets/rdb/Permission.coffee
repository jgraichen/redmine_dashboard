extend = require 'extend'
{Model, Collection} = require 'exoskeleton'

class Permission extends Model
  getAvatarUrl: ->
    @get 'avatar_url'

  getName: ->
    @get 'name'

  getType: ->
    @get 'type'

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
    @save(role: role).catch (err) =>
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

  initialize: (models, opts) ->
    @url = opts.board.url() + '/permissions'

module.exports = Permission
