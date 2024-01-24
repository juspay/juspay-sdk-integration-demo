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
    }
?>