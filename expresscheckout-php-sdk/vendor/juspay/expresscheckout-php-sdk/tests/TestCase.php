<?php

namespace Juspay\Test;

/**
 * This class exists so that the test suite is compatible with both
 * phpunit@5.7 as well as on phpunit@9.0.
 *
 * The reason for this is because newer versions of phpunit are
 * incompatible with PHP<=7.2, but PHP8 is incompatible with phpunit5.6.
 *
 * We can remove this class and these methods when we drop support for PHP 7.2 and all earlier versions.
 */
class TestCase extends \PHPUnit\Framework\TestCase
{

}