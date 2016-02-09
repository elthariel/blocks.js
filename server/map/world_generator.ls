require! {
  './seed' : {Seed}
  './image_generator' : img
  './biome_map' : {BiomeMap}
  '../../common'

}

export class WorldGenerator
  (@seed) ->
    @biome = new BiomeMap(@seed)
    height_norm = new img.ValueCombiner(@seed, [
      new img.SimplexGenerator(@seed, 100, 100)
      new img.SimplexGenerator(@seed, 300, 300)
      new img.SimplexGenerator(@seed, 600, 600)
    ], (*))
    @heightmap = new img.ValueMapper @seed, height_norm, (v) ->
      (v * 0.5 + 0.2) * 32

  generate_chunk: (cid) ->
    common.pos.ensure_cid cid
    c = new common.Chunk consts.CHUNK_SIZE, cid
    c.each (x, y, z) ~>
      cpos = common.pos.chunk_pos x, y, z
      wpos = cpos.to_world cid
      height = @heightmap.point wpos.x, wpos.z

      id = null
      if wpos.y > height
        if wpos.y > 0
          c.set_id x, y, z, common.Registry.block('Air')
        else
          c.set_id x, y, z, common.Registry.block('StillWater')
      else
        c.set_id x, y, z, common.Registry.block('Dirt')

    c
