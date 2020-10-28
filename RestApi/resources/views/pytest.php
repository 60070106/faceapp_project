<!DOCTYPE HTML>
<html lang="th">
	<head>
		<meta charset="UTF-8">
	</head>
	<body>
        ภาษาไทยปน English
        <br>
    <?php
    
        $output = shell_exec('py C:\xampp\htdocs\RestApi\resources\py\facial_processer.py สุภวัช กลิ่นขจร');
        $str = iconv('TIS-620','UTF-8', $output);

        echo $str
    ?>
	</body>
</html>