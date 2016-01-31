require! {
  \./seed : {Seed}
  \./image_generator : img
}

class WorldGenerator
  (@seed) ->
    @biome = new img.BiomeGenerator(@seed)
    height_norm = new img.ValueCombiner(@seed, [
      new img.SimplexGenerator(@seed, 100, 100)
      new img.SimplexGenerator(@seed, 300, 300)
      new img.SimplexGenerator(@seed, 600, 600)      
    ], (*))
    @height = new img.ValueMapper @seed, height_norm, (v) ->
      #(v * 0.5 + 0.4) * 64
      (v * 0.5 + 0.5) * 255

s = Seed.generate!
# console.log s.get8(0)
w = new WorldGenerator s
img.img_to_png w.height.gen(0, 1000, 0, 1000)
