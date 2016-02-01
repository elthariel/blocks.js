require! './manager' : {Manager}

Manager.add_meshes 'basic_boxes', ->
  @mesh 1 ->
    @name 'Air'
    @air true

  @mesh 2 ->
    @name 'Water'
    @texture 'blocks/water_still.png'
    @alpha 0.8

  @mesh 3 ->
    @name 'Dirt'
    @texture 'blocks/dirt.png'

# Add more here
