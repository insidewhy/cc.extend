cc.module('cc.extend').defines ->
  initing = false
  fnTest = if (/kit/.test -> kit) then /\bparent\b/ else /.*/
  cc.extend = (parent, members) ->
    prntProto = parent.prototype
    initing = true
    proto = new parent
    initing = false
    for name, member of members
      proto[name] =
        if typeof member is "function" and
        typeof prntProto[name] is "function" and
        fnTest.test member
          ->
            tmp = @parent
            @parent = prntProto[name]
            ret = member.apply this, arguments
            @parent = tmp
            return ret
        else member # TODO: store for deep copy in constructor

    if proto.init
      `function ChildClass() {`
      @init.apply this, arguments if not initing
      `}`
    else
      `function ChildClass() {}`
    ChildClass.prototype = proto
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

  cc.Class = cc.extend Function, {}
  return
# vim:ts=2 sw=2
