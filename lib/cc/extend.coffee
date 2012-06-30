cc.module('cc.extend').defines ->
  initing = false
  fnTest = if (/kit/.test -> kit) then /\bparent\b/ else /.*/

  # types which should be copied into classes
  cc.avoidCloning = (val) ->
    not val or not (val instanceof Object) or
    val instanceof cc.Class or val instanceof HTMLElement

  # clone type unless it is a designated reference type
  cc.clone = (obj) ->
    if cc.avoidCloning obj
      obj
    else
      cc.cloneCloneable obj

  # Clone obj
  # pre-condition: obj must be an array or object
  cc.cloneCloneable = (obj) ->
    if obj instanceof Array
      retObj = []
      retObj.length = obj.length
      retObj[i] = cc.clone obj[i] for i in obj
      retObj
    else
      retObj = {}
      retObj[k] = cc.clone v for k,v of obj
      retObj

  cc.extend = (parent, members) ->
    prntProto = parent.prototype
    initing = true
    proto = new parent
    initing = false
    attributes = {}
    if parent.attributes
      attributes[prntName] = prntAttr for prntName, prntAttr of parent.attributes

    for name, member of members
      if typeof member is "function"
        proto[name] =
          if typeof prntProto[name] is "function" and fnTest.test member
            do (name, member) ->
              return ->
                tmp = @parent
                @parent = prntProto[name]
                ret = member.apply this, arguments
                @parent = tmp
                return ret
          else member
      else if cc.avoidCloning member
        proto[name] = member
      else
        attributes[name] = member

    `function ChildClass() {`
    return if initing
    this[attrName] = cc.cloneCloneable attr for attrName, attr of attributes
    @init.apply this, arguments if @init
    `}`
    ChildClass.prototype = proto
    ChildClass.attributes = attributes # for deriving classes
    ChildClass.constructor = ChildClass
    ChildClass.extend = (members) -> cc.extend ChildClass, members
    ChildClass.inject = (members) -> cc.inject ChildClass, members
    ChildClass

  cc.inject = (clss, members) ->
    proto = clss.prototype
    for name, member of members
      if typeof member is "function" and
      typeof proto[name] is "function" and
      fnTest.test member
        backup = proto[name]
        proto[name] = ->
          tmp = @parent
          @parent = backup
          ret = member.apply this, arguments
          @parent = tmp
          return ret
      else
        proto[name] = member
    clss

cc.module('cc.Class').defines ->
  @set cc.extend Function, {}
  return
# vim:ts=2 sw=2
