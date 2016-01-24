
class HasEvents
  event: (name, object) ->
    handler_name = "on_#{name}"
    this[handler_name](object)

module.exports = HasEvents
