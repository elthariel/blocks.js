require! {
  chai
  '../consts'
  '../pos'
}

_it = it
expect = chai.expect

describe 'Pos' ->
  p1 = new pos.Pos(1, 2, 3)
  p1_bis = new pos.Pos(1, 2, 3)
  p2 = new pos.Pos(4, 5, 6)
  p3 = new pos.Pos(-1, -1, -1)

  _it 'has accessors' ->
    expect(p1.x).to.eq(1)
    expect(p1.y).to.eq(2)
    expect(p1.z).to.eq(3)

  _it 'converts to string' ->
    expect(p1.toString!).to.eq('1:2:3')
    expect(p1.to_s!).to.eq('1:2:3')

  _it 'converts to array' ->
    expect(p1.to_a!).to.eql([1, 2, 3])

  _it 'has operators' ->
    expect(p1.eq(p1)).to.be.true
    expect(p1.eq(p1_bis)).to.be.true
    expect(p1.eq(p2)).to.be.false

    expect(p1.neq(p1)).to.be.false
    expect(p1.neq(p2)).to.be.true


  _it 'can be updated' ->
    p = new pos.Pos(1, 2, 3)
    p.update(3, 2, 1)
    expect(p.x).to.eq(3)
    expect(p.y).to.eq(2)
    expect(p.z).to.eq(1)

describe 'WorldPos' ->
  p1 = pos.world_pos(0, 0, 0)
  p2 = pos.world_pos(-1, -1, -1)

  _it 'converts to ChunkPos' ->
    [cid1, cpos1] = p1.to_chunk!
    expect(cid1.to_a!).to.eql([0, 0, 0])
    expect(cpos1.to_a!).to.eql([0, 0, 0])

    [cid2, cpos2] = p2.to_chunk!
    expect(cid2.to_a!).to.eql([-1, -1, -1])
    expect(cpos2.to_a!).to.eql([31, 31, 31])

  _it '#same_chunk' ->
    p3 = pos.world_pos(2, 2, 2)
    expect(p1.same_chunk(p3)).to.be.true

describe 'ChunkPos' ->
  cpos1 = pos.chunk_pos(1, 1, 1)
  cid1 = pos.chunk_id(10, 10, 10)

  _it 'convert to world pos' ->
    v = consts.CHUNK_SIZE * 10 + 1
    wpos = cpos1.to_world(cid1)
    expect(wpos.to_a!).to.eql([v, v, v])
