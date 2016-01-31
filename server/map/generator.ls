
require! {
  \ndarray
  \save-pixels : save_pixels
  \./perlin
}

topng = (img) ->
  save_pixels(img, "png").pipe(process.stdout)

classify = (temp, rain) ->
  if temp > -0.5
    if rain > - 0.2
      return [11, 106, 26]
    else
      return [250, 241, 124]
  else
    if rain > 0
      return [255, 255, 255]
    else
      return [103, 65, 7]

class ImageGenerator
  (@seed) ->
    perlin.seed Math.random()

  generate: (x1, x2, y1, y2) ->
    [w, h] = [x2 - x1, y2 - y1]
    img = ndarray(new Float32Array(w * h * 3), [w, h, 3])

    for x from x1 til x2
      for y from y1 til y2
        #v3 = (Math.sin(x / 13) + Math.sin(y / 13)) / 2
        # v = v / 4 * 255
        temp = perlin.simplex2(x / 150 , y / 150)
        rain = perlin.simplex2(x / 250 , y / 250)
        #v2 = perlin.perlin2(x / 25, y / 25)
        #w = (v + v2 + v3) / 6 + 0.5
        #console.log v
        color = classify(temp, rain)
        for i til 3
          img.set x, y, i, color[i]

    return img

class ChunkGenerator
  (@seed) ->

  generate: (cid, chunk) ->
    throw new Exception('Implement me !')

gen = new ImageGenerator
img = gen.generate 0, 800, 0, 600
topng(img)


# zeros = require("zeros")
# savePixels = require("save-pixels")
# x = zeros([32, 32])
# console.log x
# x.set(16, 16, 255)
# savePixels(x, "png").pipe(process.stdout)
