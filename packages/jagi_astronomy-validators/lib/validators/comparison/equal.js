Astro.createValidator({
  name: 'equal',
  validate: function(fieldValue, fieldName, compareValue) {
    return fieldValue === compareValue;
  },
  events: {
    validationerror: function(e) {
      var fieldName = e.data.fieldName;
      var compareValue = e.data.param;

      e.setMessage(
        'The value of the "' + fieldName +
        '" field has to be equal "' + compareValue + '"'
      );
    }
  }
});
