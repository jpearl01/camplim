# Nav already stores hash in @_location ReactiveDict
# because it's really simple

Nav.hashEquals ?= (value) -> @_location.equals 'hash', value

Nav.setHash ?= (value) -> @hash = value ; @_location.set value
