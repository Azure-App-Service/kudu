<?php 

$path = $_ENV['PHP_ROOT_PATH'] . '/test/';

ob_start();

include $path . 'testmysqli.php';

$out = ob_get_clean();

echo $out;
?>
