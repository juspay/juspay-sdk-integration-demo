describe('The module', function(){
    var cut;

    beforeEach(function(){
        cut = require('../js/htmldiff');
    });

    it('should return a function', function(){
        expect(cut).is.a('function');
    });
});
