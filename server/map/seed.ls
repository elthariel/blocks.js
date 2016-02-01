require! {
  fs
}

class Seed
  @size = 1

  (@buffer) ->

  @load = (path) ->
    fd = fs.openSync(path, 'r')

    if fd < 0
      throw new Error("Unable to open #{path} for reading")

    data = new Buffer(@size)
    read_size = fs.readSync(fd, data, 0, @size)
    fs.closeSync(fd)

    if read_size != @@size
      throw new Error("Error reading seed data: #{read_size} byte read")

    new Seed(data)

  @generate = ->
    @load('/dev/urandom')

  save: (path) ->
    fd = fs.openSync(path, 'w')

    if fd < 0
      throw new Error("Unable to open #{path} for writing")

    write_size = fs.writeSync(fd, @buffer, 0, @buffer.length)
    fs.closeSync(fd)

    if write_size != @@size
      throw new Error("Unable to write seed data: #{write_size} byte written")

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
