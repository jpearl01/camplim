# add a new phase *before* 'Analyze' because we must remove matrix params
# before the path is analyzed for path params
Nav.phasor.add id:'Preanalyze', before:'Analyze'

Nav.phasor.add id:'Preanalyze', fn: ->

  # get the path
  this.path

  # split into parts (without starting slash creating a '')
  this.path[1..].split '/'

  # look for semi-colon in each part? split on semi-colon?

  # if there's a matrix param stuff, process it like a query string
  # using `qs` module... (require the query-analyzer to get `qs`)

  # store the matrix params by the content of the path in that part

  # NOTE: if the param-analyzer later decides that path part is a param,
  # then, we have to change the id of those matrix params to be the name
  # of the path param... hmm. how are we going to do that? Postanalyze phase??
  
