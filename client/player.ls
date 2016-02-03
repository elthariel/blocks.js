require! {
  \../common/player : {Player: PlayerCommon}
}

export class Player extends PlayerCommon

  (@scene, @socket, @camera) ->

    # setInterval ~>
    #   console.log @camera.position
    # , 1000
