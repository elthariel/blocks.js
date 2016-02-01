require! {
  chai
  '../../map/seed': { Seed }
  tmp
}

_it = it
chai.should!

describe 'Seed', ->
  _it 'Generates data', ->
    s = Seed.generate!
    s.buffer.length.should.eq Seed.size

  _it 'saves and reload', ->
    s = Seed.generate!
    tmp.dir (err, tmpdir) ->
      path = tmpdir + \/seed
      s.save path
      s2 = Seed.load(path)
      s.buffer.should.eq s2.buffer
      s.get8(0).should.eq s2.get(0)

  _it 'has nice accessors' ->
    s = Seed.generate!
    s.get8(0).should.eq s.get8(Seed.size)

  _it 'saves and load' ->
    path = '/tmp/blocks_seed_test'
    s = Seed.generate!
    s.save path
    s2 = Seed.load path
    s.get32(0).should.eq s2.get32(0)
    s.get32(10).should.eq s2.get32(10)
