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
