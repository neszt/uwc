<?php

$res = array();

while($f = fgets(STDIN)){
	preg_match_all("/([a-z']+)/i", $f, $matches, PREG_SET_ORDER);
	foreach ($matches as $k => $v) {
		if ( !isset($res[$v[0]]) ) {
			$res[$v[0]] = 1;
		} else {
			$res[$v[0]]++;
		}
	}
}

uksort($res, function($a, $b) use ($res) {
	if ( $res[$a] == $res[$b] ) {
		return strcmp($a, $b);
	}
	return $res[$a] - $res[$b];
});

foreach ( $res as $k => $v ) {
	print "$k $v\n";
}

?>
