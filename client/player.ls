require! {
  \../common/player : PlayerCommon
}

class Player extends PlayerCommon

  (@scene, @socket, @camera) ->

    # setInterval ~>
    #   console.log @camera.position
    # , 1000

module.exports = Player
