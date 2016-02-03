require! \./base : {Base}

export class Nil extends Base
  @register 0

export class Air extends Base
  @register 1

export class Stone extends Base
  @register 2

export class Grass extends Base
  @register 3

export class Dirt extends Base
  @register 4

export class CobbleStone extends Base
  @register 5

export class FlowingWater extends Base
  @register 6

export class StillWater extends Base
  @register 7

export class FlowingLava extends Base
  @register 8

export class StillLava extends Base
  @register 9

export class Sand extends Base
  @register 10

export class Gravel extends Base
  @register 11

export class Glass extends Base
  @register 21
