describe('renderOperations', function(){
    var cut, res, createToken, tokenize;

    beforeEach(function(){
        var diff = require('../js/htmldiff');
        createToken = diff.findMatchingBlocks.createToken;

        tokenize = function(tokens){
            return tokens.map(function(token){
                return createToken(token);
            });
        };

        cut = function(before, after){
            var ops = diff.calculateOperations(before, after);
            return diff.renderOperations(before, after, ops);
        };
    });

    it('should be a function', function(){
        expect(cut).is.a('function');
    });

    describe('equal', function(){
        beforeEach(function(){
            var before = tokenize(['this', ' ', 'is', ' ', 'a', ' ', 'test']);
            res = cut(before, before);
        });

        it('should output the text', function(){
            expect(res).equal('this is a test');
        });
    });

    describe('insert', function(){
        beforeEach(function(){
            before = tokenize(['this', ' ', 'is']);
            after = tokenize(['this', ' ', 'is', ' ', 'a', ' ', 'test']);
            res = cut(before, after);
        });

        it('should wrap in an <ins>', function(){
            expect(res).equal('this is<ins data-operation-index="1"> a test</ins>');
        });
    });

    describe('delete', function(){
        beforeEach(function(){
            var before = tokenize(['this', ' ', 'is', ' ', 'a', ' ', 'test',
            ' ', 'of', ' ', 'stuff']);
            var after = tokenize(['this', ' ', 'is', ' ', 'a', ' ', 'test']);
            res = cut(before, after);
        });

        it('should wrap in a <del>', function(){
            expect(res).to.equal('this is a test<del data-operation-index="1"> of stuff</del>');
        });
    });

    describe('replace', function(){
        beforeEach(function(){
            var before = tokenize(['this', ' ', 'is', ' ', 'a', ' ', 'break']);
            var after = tokenize(['this', ' ', 'is', ' ', 'a', ' ', 'test']);
            res = cut(before, after);
        });

        it('should wrap in both <ins> and <del>', function(){
            expect(res).to.equal('this is a <del data-operation-index="1">break</del>' +
                    '<ins data-operation-index="1">test</ins>');
        });
    });

    describe('Dealing with tags', function(){
        var before, after;

        beforeEach(function(){
            before = tokenize(['<p>', 'a', '</p>']);
            after = tokenize(['<p>', 'a', ' ', 'b', '</p>', '<p>', 'c', '</p>']);
            res = cut(before, after);
        });

        it('should identify contained inserted tags', function(){
            expect(res).to.equal('<p>a<ins data-operation-index="1"> b</ins></p>' +
                    '<p data-diff-node="ins" data-operation-index="3">' +
                    '<ins data-operation-index="3">c</ins></p>');
        });

        it('should identify contained deleted tags', function(){
            res = cut(after, before);

            expect(res).to.equal('<p>a<del data-operation-index="1"> b</del></p>' +
                    '<p data-diff-node="del" data-operation-index="3">' +
                    '<del data-operation-index="3">c</del></p>');
        });

        it('should not identify partial tags', function(){
            var before = tokenize(['test', '</b>', 'non-bold']);
            var after = tokenize(['test!', '</b>', 'non-bold', '<b>', 'bold']);
            res = cut(before, after);

            expect(res).to.equal('<del data-operation-index="0">test</del>' +
                    '<ins data-operation-index="0">test!</ins></b>non-bold<b>' +
                    '<ins data-operation-index="2">bold</ins>');
        });

        describe('When there is a change at the beginning, in a <p>', function(){
            beforeEach(function(){
                var before = tokenize(['<p>', 'this', ' ', 'is', ' ', 'awesome', '</p>']);
                var after = tokenize(['<p>', 'I', ' ', 'is', ' ', 'awesome', '</p>']);
                res = cut(before, after);
            });

            it('should keep the change inside the <p>', function(){
                expect(res).to.equal('<p><del data-operation-index="1">this</del>' +
                        '<ins data-operation-index="1">I</ins> is awesome</p>');
            });
        });
    });

    describe('empty tokens', function(){
        it('should not be wrapped', function(){
            var before = tokenize(['text']);
            var after = tokenize(['text', ' ']);

            res = cut(before, after);

            expect(res).to.equal('text');
        });
    });

    describe('tags with attributes', function(){
        it('should treat attribute changes as equal and output the after tag', function(){
            var before = tokenize(['<p>', 'this', ' ', 'is', ' ', 'awesome', '</p>']);
            var after = tokenize(['<p style="margin: 2px;" class="after">', 'this', ' ', 'is', ' ',
                    'awesome', '</p>']);

            res = cut(before, after);

            expect(res).to.equal('<p style="margin: 2px;" class="after">this is awesome</p>');
        });

        it('should show changes within tags with different attributes', function(){
            var before = tokenize(['<p>', 'this', ' ', 'is', ' ', 'awesome', '</p>']);
            var after = tokenize(['<p style="margin: 2px;" class="after">', 'that', ' ', 'is', ' ',
                    'awesome', '</p>']);

            res = cut(before, after);

            expect(res).to.equal('<p style="margin: 2px;" class="after">' +
                    '<del data-operation-index="1">this</del><ins data-operation-index="1">' +
                    'that</ins> is awesome</p>');
        });
    });

    describe('wrappable tags', function(){
        it('should wrap void tags', function(){
            var before = tokenize(['old', ' ', 'text']);
            var after = tokenize(['new', '<br/>', ' ', 'text']);

            res = cut(before, after);

            expect(res).to.equal('<del data-operation-index="0">old</del>' +
                    '<ins data-operation-index="0">new<br/></ins> text');
        });

        it('should wrap atomic tags', function(){
            var before = tokenize(['old', '<iframe src="source.html"></iframe>', ' ', 'text']);
            var after = tokenize(['new', ' ', 'text']);

            res = cut(before, after);

            expect(res).to.equal(
                    '<del data-operation-index="0">old<iframe src="source.html"></iframe></del>' +
                    '<ins data-operation-index="0">new</ins> text');
        });
    });
});
