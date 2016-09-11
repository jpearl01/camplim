Astro.createValidator
  name: 'beforeNow',
  validate: (fieldValue, fieldName) ->
    if fieldValue?
      fieldValue.getTime() < (Date.now() + 1000)
    else
      return true # TODO: true if `optional` field, if not optional, they should use require()

  events:
    validationError: (e) ->
      e.setMessage "#{e.data.param ? e.data.fieldName} must be in the past"

Astro.createValidator
  name: 'phone',
  validate: (fieldValue) ->
    if fieldValue?.length > 0
      # must have at least 10 digits, any format is allowed
      digit = /\d/
      count = 0
      count++ for ch in fieldValue when digit.test ch
      return count >= 10
    else
      return true

  events:
    validationError: (e) ->
      e.setMessage "Phone number must contain at least 10 digits"
