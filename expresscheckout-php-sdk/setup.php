<?php
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        system("composer_installer.bat");
    } else if (strtoupper(substr(PHP_OS, 0, 6))  === 'DARWIN') {
        $output = shell_exec('test -e "$(command -v comp)" && echo 1 || echo 0');
        if ($output == 0) {
            echo "composer already installed" . PHP_EOL;
        } else {
            system('brew install composer');
        }
    } else {
        shell_exec("composer_installer.sh");
        if (!extension_loaded("gmp")) {
            $output=null;
            $exitCode=null;
            exec('sh ext_installer.sh gmp', $output, $exitCode);
            if ($exitCode === 0) {
                print_r($output);
                echo PHP_EOL. "gmp extension added successfully" . PHP_EOL;
            } else {
                print_r($output);
                echo PHP_EOL . "failed enabling gmp extension manually install from: https://www.php.net/manual/en/gmp.installation.php" . PHP_EOL;
                if (!extension_loaded("bcmath")) {
                    $output=null;
                    $exitCode=null;
                    exec('sh package_install.sh bcmath', $output, $exitCode);
                    if ($exitCode === 0) {
                        print_r($output);
                        echo PHP_EOL. "bcmath extension added successfully" . PHP_EOL;
                    } else {
                        print_r($output);
                        echo PHP_EOL . "failed enabling bcmath extension manually install from: https://www.php.net/manual/en/bc.installation.php" . PHP_EOL;
                    }
                }
            }
        } else {
            echo "gmp extension enabled" . PHP_EOL;
        }
    }
?>