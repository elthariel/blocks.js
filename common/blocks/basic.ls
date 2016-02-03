require! \./base : {Base}

class Nil extends Base
  @register 0

class Air extends Base
  @register 1

class Water extends Base
  @register 2

class Dirt extends Base
  @register 3

class Cobblestone extends Base
  @register 4

class Sand extends Base
  @register 5

class Gravel extends Base
  @register 6

class Coal extends Base
  @register 7

class Iron extends Base
  @register 8

module.exports = {
  Nil
  Air
  Water
  Dirt
  Cobblestone
  Sand
  Gravel
  Coal
  Iron
}
