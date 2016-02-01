require! './image_generator' : {Generator, SimplexGenerator}

class BiomeMap extends Generator
  (seed) ->
    super seed
    @temp_img = new SimplexGenerator(seed, 242, 242)
    @rain_img = new SimplexGenerator(seed, 150, 150)

  normalize: (temp, rain) ->
    temp = temp * 0.5 + 0.5
    rain = rain * 0.5 + 0.5
    total = temp + rain
    if total > 1
      offset = (1 - total) / 2
      return [temp - offset, rain - offset]
    else
      return [temp, rain]

  point: (x, y) ->
    [temp, rain] = @normalize(@temp_img.point x, y,
                              @rain_img.point x, y)
    temp = 1 - temp # Invert axis

    if temp < 0.2
      return 0 # tundra
    if rain > 0.8
      return 1 # tropical forest

    if rain < 0.1
      return 2 # Desert
    else if rain < 0.4
      if temp > 0.5
        return 3 # Savanna
      else
        return 4 # Plain
    else
      if temp < 0.4
        return 5 # forest
      else
        return 6 # Dense forest

module.exports = {BiomeMap}
