In order to catch the ajaxComplete event on spawning new locations, we need to change prefetch() ajax settings to global: true
It is in the prefetch function (around line #631 as I write this)

global: false   => global: true

