require! './manager' : {Manager}

Manager.add_meshes 'basic_boxes', ->
  @mesh 1 ->
    @name 'Air'
    @air true

  @mesh 2 ->
    @name 'Stone'
    @texture 'blocks/stone.png'
    @texture_repeat 2

  @mesh 3 ->
    @name 'Grass'
    @texture 'blocks/grass_top.png'
    @color '#1aad17'
    @texture_repeat 2
    # @texture [
    #   'blocks/grass_top.png',
    #   'blocks/grass_side.png',
    #   'blocks/grass_side.png',
    #   'blocks/grass_side.png',
    #   'blocks/grass_side.png',
    #   'blocks/grass_side.png',
    # ]

  @mesh 4 ->
    @name 'Dirt'
    @texture 'blocks/dirt.png'


  @mesh 7 ->
    @name 'Water'
    @texture 'blocks/water_still.png'
    @alpha 0.8


# Add more here
