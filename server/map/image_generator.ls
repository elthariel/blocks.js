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

class NoiseGenerator extends Generator
  (seed, @freq) ->
    super seed

  point: (x, y) ->
    v = Math.floor(Math.random() * (@freq / 2))
    if v == 0
      255
    else
      0

img_to_png = (img) ->
  save_pixels(img, "png").pipe(process.stdout)

module.exports = {
  Generator,
  PerlinGenerator,
  SimplexGenerator,
  NoiseGenerator
  ValueMapper,
  ValueCombiner,
  img_to_png
}

# Official test leakage
# s = Seed.generate!
# g = new NoiseGenerator(s, 1000)
# img = g.gen(0, 1000, 0, 1000)
# img_to_png img
