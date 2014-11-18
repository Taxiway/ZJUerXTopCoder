<html>
<body>
<head><meta http-equiv=Content-Type content="text/html; charset=utf-8">
<title>Dual</title><link rel="stylesheet" href="dual.css" type="text/css" /></head>
<h1 class = "headLine">Dual between ZJUers</h1>
<?php
$handle1 = !empty($_GET["handle1"]) ? $_GET["handle1"] : "";
$handle2 = !empty($_GET["handle2"]) ? $_GET["handle2"] : "";
echo "<form action=\"dual.php\" method=\"get\">\n";
echo "Handle1: <input type=\"text\" name=\"handle1\" value=\"" . $handle1 . "\" />\n";
echo "Handle2: <input type=\"text\" name=\"handle2\" value=\"" . $handle2 . "\" />\n";
echo "<input type=\"submit\" />\n";
echo "</form>\n";
if ($handle1 != "" && $handle2 != "") {
	$file = fopen("duallog.txt", "a+");
	fputs($file, $handle1 . " vs " . $handle2 . "\n");
	fputs($file, date(DATE_RFC822) . "\n");
	fclose($file);
	$filename1 = "../History/" . strtolower($handle1) . ".xtx";
	$filename2 = "../History/" . strtolower($handle2) . ".xtx";
	if (file_exists($filename1) && file_exists($filename2)) {
		$file1 = fopen($filename1,"r");
		$file2 = fopen($filename2,"r");
		$handle1 = rtrim(fgets($file1));
		$id1 = rtrim(fgets($file1));
		$colortext1 = rtrim(fgets($file1));
		$size1 = 0;
		while (!feof($file1)) {
			$roundind1[$size1] = rtrim(fgets($file1));
			$roundid1[$size1] = rtrim(fgets($file1));
			$roundname1[$size1] = rtrim(fgets($file1));
			$division1[$size1] = rtrim(fgets($file1));
			$rank1[$size1] = rtrim(fgets($file1));
			$score1[$size1] = rtrim(fgets($file1));
			$color1[$size1] = rtrim(fgets($file1));
			++$size1;
		}
		--$size1;
		fclose($file1);
		$handle2 = rtrim(fgets($file2));
		$id2 = rtrim(fgets($file2));
		$colortext2 = rtrim(fgets($file2));
		$size2 = 0;
		while (!feof($file2)) {
			$roundind2[$size2] = rtrim(fgets($file2));
			$roundid2[$size2] = rtrim(fgets($file2));
			$roundname2[$size2] = rtrim(fgets($file2));
			$division2[$size2] = rtrim(fgets($file2));
			$rank2[$size2] = rtrim(fgets($file2));
			$score2[$size2] = rtrim(fgets($file2));
			$color2[$size2] = rtrim(fgets($file2));
			++$size2;
		}
		--$size2;
		fclose($file2);
		echo "<div>\n";
		echo "<h2>\n";
		echo "<a href=\"member/" . $id1 . ".html\" class=\"" . $colortext1 . "\">" . $handle1 . "</a> vs <a href=\"member/" . $id2 . ".html\" class=\"" . $colortext2 . "\">" . $handle2 . "</a>\n";
		echo "</h2>\n";
		echo "<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tbody>\n";
		echo "\t<tr class=\"titleLine\">\n";
		echo "\t\t<td><span>Event</span></td>\n";
		echo "\t\t<td><span>Division</span></td>\n";
		echo "\t\t<td><span>Place1</span></td>\n";
		echo "\t\t<td><span>Score1</span></td>\n";
		echo "\t\t<td><span>Place2</span></td>\n";
		echo "\t\t<td><span>Score2</span></td>\n";
		echo "\t\t<td><span>Win1</span></td>\n";
		echo "\t\t<td><span>Win2</span></td>\n";
		echo "\t</tr>\n";
		$win1 = 0;
		$win2 = 0;
		$ind1 = 0;
		$ind2 = 0;
		while (($ind1 < $size1) && ($ind2 < $size2)) {
			if ($roundind1[$ind1] == $roundind2[$ind2]) {
				if ($division1[$ind1] == $division2[$ind2]) {
					if (intval($rank1[$ind1]) < intval($rank2[$ind2])) {
						++$win1;
					}
					elseif (intval($rank1[$ind1]) > intval($rank2[$ind2])) {
						++$win2;
					}
				}
				++$ind1;
				++$ind2;
			}
			elseif ($roundind1[$ind1] < $roundind2[$ind2]) {
				++$ind2;
			}
			else {
				++$ind1;
			}
		}
		
		$ind1 = 0;
		$ind2 = 0;
		while (($ind1 < $size1) && ($ind2 < $size2)) {
			if ($roundind1[$ind1] == $roundind2[$ind2]) {
				if ($division1[$ind1] == $division2[$ind2]) {
					echo "\t<tr>\n";
					echo "\t\t<td><a href=\"rank/" . $roundid1[$ind1] . ".html\" class=\"eventText\">" . $roundname1[$ind1] . "</a></td>\n";
					echo "\t\t<td><span>" . $division1[$ind1] . "</span></td>\n";
					echo "\t\t<td><span class=\"" . $color1[$ind1] . "\">" . $rank1[$ind1] . "</span></td>\n";
					echo "\t\t<td><span class=\"" . $color1[$ind1] . "\">" . $score1[$ind1] . "</span></td>\n";
					echo "\t\t<td><span class=\"" . $color2[$ind2] . "\">" . $rank2[$ind2] . "</span></td>\n";
					echo "\t\t<td><span class=\"" . $color2[$ind2] . "\">" . $score2[$ind2] . "</span></td>\n";
					echo "\t\t<td><span>" . $win1 . "</span></td>\n";
					echo "\t\t<td><span>" . $win2 . "</span></td>\n";
					echo "\t</tr>\n";
					if (intval($rank1[$ind1]) < intval($rank2[$ind2])) {
						--$win1;
					}
					elseif (intval($rank1[$ind1]) > intval($rank2[$ind2])) {
						--$win2;
					}
				}
				++$ind1;
				++$ind2;
			}
			elseif ($roundind1[$ind1] < $roundind2[$ind2]) {
				++$ind2;
			}
			else {
				++$ind1;
			}
		}
		echo "</tbody></table></div>\n";
	}
	else {
		echo "<div>\n";
		if (file_exists($filename2)) {
			echo "<h2>Handle " . $handle1 . " no found.</h2><br/>\n";
		}
		else if (file_exists($filename1)) {
			echo "<h2>Handle " . $handle2 . " no found.</h2><br/>\n";
		}
		else {
			echo "<h2>Handles " . $handle1 . " and " . $handle2 . " no found.</h2><br/>\n";
		}
		echo "</div>";
	}
}
?>
<div class="backDiv">
<h3><a href="ZJUerXTCer.html" class="backLink">Back to homepage</h3>
</div>
</body>
</html>
