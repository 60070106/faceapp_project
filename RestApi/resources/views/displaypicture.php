<?php
$link = mysqli_connect("127.0.0.1", "root", "", "picture") or die(mysqli_connect_error());

$id = $_GET['id'];
$sql = "SELECT * FROM facial_picture WHERE id = $id";
$result = mysqli_query($link, $sql);
$row = mysqli_fetch_assoc($result);
mysqli_close($link);

echo '<img src="data:image/jpeg;base64,'.$row['img'].'"/>';

?>