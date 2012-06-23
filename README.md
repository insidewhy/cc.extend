# cc.extend
A simple class creation system allowing methods, attributes and access to
super methods from classes.

# installation
To install globally:
```
sudo npm install -g cc.extend
```

# usage
## cc.extend - class inheritance
```javascript
var Animal = cc.extend(Function, {}) // or cc.Class
```

## constructors and methods
cc.extend adds ".extend" as an instance method of the returned class which
can be used to simplify subclassing:
```javascript
var Cat = Animal.extend({
  init: function(name) {
    // init is called as a constructor
    console.log('cat')
  },
  talk: function(word) {
    console.log('hiss (' + word + ')')
  }
})
```

## attributes and calling super methods
parent can be called in any method to call the parent version of that method. Non-function values in an extend object become class attributes.
```javascript
var HouseCat = Cat.extend({
  type: 'friendly cat',
  talk: function(word) {
    console.log(this.type + ': meow')
    this.parent(word)
  }
})

// construction of the housecat will log 'cat'
var animal = new HouseCat,
    isTrue = (animal instanceof Animal)

animal.talk('mose') // logs "friendly cat: meow", "hiss(mose)"
```

## using inject to modify a class in place.
cc.extend returns a new child class whilst cc.inject can be used to modify a class. Inside of a method overriden with cc.inject, "parent" refers to the overwridden method.
```javascript
// a class created with cc.extend also gets a static "inject" method.
HouseCat.inject({
  talk: function(word) {
    // call non-injected version of HouseCat.talk().
    this.parent(word)
    log('prr')
  }
}).inject({
  talk: function(word) {
    log('prr prr')
    this.parent(word) // call inject function defined above
  }
})

animal.talk('kit') // logs "prr prr", "friendly cat: meow", "hiss(kit)", "prr"
```

# testing
```
% git clone git://github.com/nuisanceofcats/cc.extend.git
% cd cc.extend
% npm test
cc.extend test server listening on: 8013
please go to http://localhost:8013/
```

# faq
 * The API is a (mainly) compatible rewrite and extension of [ImpactJS' class system](http://impactjs.com/documentation/class-reference/class). The technical details are explained [here](http://blog.buymeasoda.com/understanding-john-resigs-simple-javascript-i). 
