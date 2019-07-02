<?php
// 导出你的 p12　文件，使用 `openssl pkcs12 -in apns_develop.p12 -out apns_develop.pem -nodes` 导出 pem


$token_production = '0b870aa5d0b45116a1bcd11591aa61d214bc524ddb8ba7c0e0e32dd4c6910a13';
$token_sandbox = 'a2c38047cc2d565e2753f1ee6b5376af037101b73d92ed40253fb7a9e7cce80c';

/*
开发状态服务器地址 gateway.sandbox.push.apple.com 2195
产品状态服务器地址 gateway.push.apple.com 2195
*/
$cert_name = '';
$ssl_URL = '';
$is_dev = 1;  // 0:sandbox  1:production
$deviceToken = '';

if ($is_dev == 0) {
    $cert_name = 'apns_develop.pem';
    $ssl_URL = 'ssl://gateway.sandbox.push.apple.com:2195';
    $deviceToken = $token_sandbox;
} else {
    $cert_name = 'apns_production.pem';
    $ssl_URL = 'ssl://gateway.push.apple.com:2195';
    $deviceToken = $token_production;
}

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', $cert_name);
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);


$fp = stream_socket_client($ssl_URL,
                            $err,
                            $errstr,
                            60,
                            STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT,
                            $ctx);

//if (!$fp)
//exit("Failed to connect amarnew: $err $errstr" . PHP_EOL);

//echo 'Connected to APNS' . PHP_EOL;
$message = "你好";

// Create the payload body
$body['aps'] = array(
    'badge' => +1,
    'alert' => $message,
    'sound' => 'default'
);

$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
    echo 'Message not delivered' . PHP_EOL;
else
    echo 'Message successfully delivered amar, message is :'.$message. PHP_EOL;

// Close the connection to the server
fclose($fp);
