<?php
	require_once("config.php");
	require_once("Db.class.php");
	require_once("common.php");
	
	if (!preg_match('![0-9a-zA-Z]{32}/[0-9a-fA-F]{2,1500}/[0-9a-fA-F]{32}!', $_SERVER['QUERY_STRING']))
	{
		echo "INVALID_DATA\n";
		die();
	}

	list($logkey, $data, $hash) = explode('/', $_SERVER['QUERY_STRING']);
	
	if (strlen($data) % 2 != 0)
	{
		echo "INVALID_DATA\n";
		die();
	}
	
	// Db class connects to the database, sets the character set
	// (UTF-8), sets the names (UTF-8) and selects the database
	
	$sql = "SELECT user_id, logsecret FROM user WHERE logkey = " . Db::Escape($logkey) . " AND status = 'enabled'";
	$result = Db::Query($sql);;
	if (!$result)
	{
		echo "INVALID_LOGKEY\n";
		die();
	}
	
	$user_id = (int) $result[0]['user_id'];
	$logsecret = $result[0]['logsecret'];
	$expected_hash = md5($data . "," . $logsecret);
	
	if ($expected_hash != strtolower($hash))
	{
		echo "INVALID_HASH\n";
		die();
	}
	
	$tmp = explode(".", uniqid("", true));
	$uuid = $tmp[0] . $tmp[1];
	$sql = "INSERT INTO entry (user_id, timestamp, uuid, data) VALUES (" . Db::Escape($user_id) . ", UNIX_TIMESTAMP(), " . Db::Escape($uuid) . ", 0x" . $data . ")";
	try
	{
		Db::Query($sql);
	}
	catch (Exception $e)
	{
		echo "ERROR\n";
		die();
	}
	
	echo "OK " . $uuid . "\n";
?>
