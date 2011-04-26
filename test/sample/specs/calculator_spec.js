describe('Calculator', function () {
  var calc;

  beforeEach(function () {
    calc = new Calculator(2);
  });

  it('adds values', function() {
    calc.add(2);

    expect(calc.value).toEqual(4);
  });

  it('multiplies values', function() {
    calc.multiply(3);

    expect(calc.value).toEqual(6);
  });
});
