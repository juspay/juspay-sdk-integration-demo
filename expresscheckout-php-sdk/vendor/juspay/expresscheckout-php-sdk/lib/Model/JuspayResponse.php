<?php

namespace Juspay\Model;

class JuspayResponse extends JuspayEntity {
    public static $result = [];
    public function __get($name) {
        if ($name == "*") return self::$result;
        return self::$result[$name];
    }

    public function __construct($params) {
        $params = $this->camelizeArrayKeysRecursive($params);
        foreach( array_keys($params) as $key) {
            self::$result[$key] = $params[$key];
        }
    }
}