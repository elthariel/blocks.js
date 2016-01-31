require! {
  fs
  crypto
}

class Seed
  @size = 1

  @load = (path) ->
    fd = fs.openSync(path, 'r')

    if fd < 0
      throw new Exception("Unable to open #{path} for reading")

    data = new Buffer(@size)
    read_size = fs.readFileSync(fd, data, 0, @size)
    fs.closeSync(fd)

    if read_size != @@size
      throw new Exception("Error reading seed data #{read_size}")

    new Seed(data)

  @generate = ->
    new Seed(crypto.randomBytes(@size))

  (@buffer) ->

  save: (path) ->
    fd = fs.openSync(path, 'w')

    if fd < 0
      throw new Exception("Unable to open #{path} for writing")

    write_size = fd.writeFileSync(fd, @buffer)
    fs.closeSync(fd)

    if write_size != @@size
      throw new Exception("Unable to write seed data #{write_size}")

  get8: (x) ->
    x = x % @@size
    @buffer[x]

  get16: (x) ->
    @get8(x + 1) .<<. 8 + @get8(x)

  get32: (x) ->
    @get16(x + 2) .<<. 16 + @get16(x)

  get64: (x) ->
    @get32(x + 4) .<<. 32 + @get32(x)


module.exports = {Seed}
