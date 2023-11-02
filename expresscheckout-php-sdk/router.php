<?php
$url = $_SERVER['REQUEST_URI'];

$url = explode('?', $url)[0];

$routes = [
    '/' => 'index.html',
    '/handleJuspayResponse' => 'handleJuspayResponse.php',
    '/initiateJuspayPayment' => 'initiateJuspayPayment.php',
];

if (isset($routes[$url])) {
    include($routes[$url]);
} else {
    http_response_code(404);
    echo '404 Not Found';
}