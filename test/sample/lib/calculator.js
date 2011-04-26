function Calculator(initialValue) {
  this.value = initialValue;
}

Calculator.prototype = {
  add: function(val) {
    this.value += val;
  },
  multiply: function(val) {
    this.value *= val;
  },
  sub: function(val) {
    this.value -= val;
  }
};
