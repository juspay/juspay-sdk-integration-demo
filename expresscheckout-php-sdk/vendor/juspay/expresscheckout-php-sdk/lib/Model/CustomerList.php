<?php

namespace Juspay\Model;

/**
 * Class CustomerList
 *
 * @package Juspay\Model
 */
class CustomerList extends JuspayEntityList {

    /**
     * Constructor
     *
     * @param array $params
     */
    public function __construct($params) {
        parent::__construct ( $params );
        for($i = 0; $i < sizeof ( $params ["list"] ); $i ++) {
            $this->list [$i] = new Customer ( $params ["list"] [$i] );
        }
    }
}
