<?php

namespace Juspay\Model;

/**
 * Class OrderList
 *
 * @package Juspay\Model
 */
class OrderList extends JuspayEntityList {
    
    /**
     * Constructor
     *
     * @param array $params
     */
    public function __construct($params) {
        parent::__construct ( $params );
        for($i = 0; $i < sizeof ( $params ["list"] ); $i ++) {
            $this->list [$i] = new Order ( $params ["list"] [$i] );
        }
    }
}
