describe('The specs from the ruby source project', function(){
    var cut;

    beforeEach(function(){
        cut = require('../js/htmldiff');
    });

    it('should diff text', function(){
        var diff = cut('a word is here', 'a nother word is there');
        expect(diff).equal('a<ins data-operation-index="1"> nother</ins> word is ' +
                '<del data-operation-index="3">here</del><ins data-operation-index="3">' +
                'there</ins>');
    });

    it('should insert a letter and a space', function(){
        var diff = cut('a c', 'a b c');
        expect(diff).equal('a <ins data-operation-index="1">b </ins>c');
    });

    it('should remove a letter and a space', function(){
        var diff = cut('a b c', 'a c');
        diff.should == 'a <del data-operation-index="1">b </del>c';
    });

    it('should change a letter', function(){
        var diff = cut('a b c', 'a d c');
        expect(diff).equal('a <del data-operation-index="1">b</del>' +
                '<ins data-operation-index="1">d</ins> c');
    });
});
