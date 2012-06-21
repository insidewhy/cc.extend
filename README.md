# cc.extend
A simple class creation system allowing methods, attributes and access to
super methods from classes.

# installation
To install globally:
```
sudo npm install -g cc.extend
```

# usage
Create a child/parent class relationship.
```javascript
var Animal = cc.extend(Function, {}) // or cc.Class

var Cat = Animal.extend({
  init: function(name) {
    // constructor
    console.log("cat")
  },
  talk: function(word) {
    console.log("hiss (" + word + ")")
  }
})

var HouseCat = Cat.extend({
  talk: function(word) {
    console.log("meow")
    this.parent(word)
  }
})

var animal = new HouseCat,
    isTrue = (animal instanceof Animal)

animal.talk('mose')
```

# testing
```
% git clone git://github.com/nuisanceofcats/cc.extend.git
% cd cc.extend
% npm test
cc.extend test server listening on: 8013
please go to http://localhost:8013/
```

# FAQ
 * Is this your idea? No I got it from [here](http://blog.buymeasoda.com/understanding-john-resigs-simple-javascript-i)
