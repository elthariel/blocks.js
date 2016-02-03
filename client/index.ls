window <<< require 'prelude-ls'
window.bjs = BABYLON
require! './game' : {Game}

console.log 'Starting Blocks...'
new Game
