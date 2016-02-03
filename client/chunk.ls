require! {
  \../common
  \./block
  \./scene
}

export class Chunk extends common.Chunk

  ->
    super!
    scene!createOrUpdateSelectionOctree();
