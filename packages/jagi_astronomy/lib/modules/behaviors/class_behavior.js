Astro.ClassBehavior = function ClassBehavior(classBehaviorDefinition) {
  this.behavior = classBehaviorDefinition.behavior;
  this.options = classBehaviorDefinition.options;
  // TODO: need a connection from a behavior to thing it's being applied to
  this.definition = this.behavior.createSchemaDefinition(this.options, classBehaviorDefinition.Class);
  _.extend(this, this.behavior.methods);
};

Astro.ClassBehavior.prototype.callMethod = function(methodName, doc) {
  var method = this.behavior.methods[methodName];
  if (!_.isFunction(method)) {
    throw new Error(
      'The "' + methodName + '" method in the "' +
      this.behavior.name + '" behavior does not exist '
    );
  }

  return method.call(doc);
};
