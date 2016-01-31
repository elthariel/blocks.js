global import require \prelude-ls

require! {
  ndarray
  \./seed : {Seed}
  \./perlin
  \save-pixels : save_pixels
}

class Generator
  (@seed) ->

  gen: (x1, x2, y1, y2) ->
    [w, h] = [x2 - x1, y2 - y1]
    img = ndarray(new Float32Array(w * h), [w, h])

    for x from x1 til x2
      for y from y1 til y2
        img.set x, y, @point(x, y)
    img

  point: (x, y) ->
    return 0

class PerlinGenerator extends Generator
  (s, @scale_x = 100, @scale_y = 100, @offset_x = 0, @offset_y = 0) ->
    super s
    perlin.seed s.get16(0)

  point: (x, y) ->
    perlin.perlin2 (x / @scale_x) + @offset_x, (y / @scale_y) + @offset_y

class SimplexGenerator extends PerlinGenerator
  point: (x, y) ->
    perlin.simplex2 (x / @scale_x) + @offset_x, (y / @scale_y) + @offset_y

class BiomeGenerator extends Generator
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

class ValueMapper extends Generator
  (seed, @wrapped, @mapper) ->
    super seed

  point: (x, y) ->
    value = @wrapped.point x, y
    @mapper(value)

class ValueCombiner extends Generator
  (s, @generators, @combiner) ->
    super s

  point: (x, y) ->
    values = map (.point x, y), @generators
    @combiner.apply(@, values)

class Test extends Generator
  (seed, @freq = 100) ->
    super s

  point: (x, y) ->
    v = perlin.simplex2(x / 10, y / 10) + perlin.simplex2(x / 10 + 10, y / 10 + 10)
    if v == 0
      return 255
    else
      return 0

class NoiseGenerator extends Generator
  (seed, freq) ->
    super seed

  point: (x, y) ->
    v = Math.floor(Math.rand() * (@freq / 2))
    v == 0

img_to_png = (img) ->
  save_pixels(img, "png").pipe(process.stdout)

module.exports = {
  Generator,
  PerlinGenerator,
  SimplexGenerator,
  BiomeGenerator,
  ValueMapper,
  ValueCombiner,
  img_to_png
}
#
s = Seed.generate!
# g = new BiomeGenerator(s)
# b = new ValueMapper s, g, (v) ->
#   (v / 6) * 255
g = new Test(s, 100)
img = g.gen(0, 1000, 0, 1000)
img_to_png img
