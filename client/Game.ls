require! <[ ./Map ./Player ]>

class Game

  login: \champii

  (@socket) ->
    @handshake!

  handshake: ->
    @socket.on \hello ~>
      @socket.on \welcome @~start
      @socket.emit \hello @login

  start: (pos) ->
    @player = new Player pos
    @map = new Map


module.exports = new Game
