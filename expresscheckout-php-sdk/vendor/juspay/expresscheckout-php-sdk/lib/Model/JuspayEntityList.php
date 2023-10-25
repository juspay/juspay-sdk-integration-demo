<?php

namespace Juspay\Model;

/**
 * Class JuspayEntityList
 *
 * @property array $list
 * @property int $count
 * @property int $offset
 * @property int $total
 *
 * @package Juspay\Model
 */
abstract class JuspayEntityList {

    public $list = [];
    public $count;

    public $offset;

    public $total;
    /**
     * Constructor
     *
     * @param array $params
     */
    public function __construct($params) {
        $this->count = $params ["count"];
        $this->offset = $params ["offset"];
        $this->total = $params ["total"];
        $this->list = array ();
    }
}
