INDEX_SIDE_BAR = <<END
<div class = "divToolStat">
<h2>Tools</h2>
<table border="0" cellspacing="0" cellpadding="0"><tbody>
	<tr class="titleLine">
		<td><span>Dual</span></td>
	</tr>
	<tr class="dualLine">
		<td><a href="dual.php" class="dual">Dual between ZJUers</a></td>
	</tr>
</tbody></table>
<h2>Statistics</h2>
<table border="0" cellspacing="0" cellpadding="0"><tbody>
	<tr class="titleLine">
		<td><span>Rating</span></td>
	</tr>
	<tr>
		<td><a href="stats/toprating.html" class="statText">Top 20 with highest rating</a></td>
	</tr>
	<tr>
		<td><a href="stats/topratingactive.html" class="statText">Top 20 with highest rating (active)</a></td>
	</tr>
	<tr>
		<td><a href="stats/topmaxrating.html" class="statText">Top 20 with highest max rating</a></td>
	</tr>
	<tr>
		<td><a href="stats/topmaxratingactive.html" class="statText">Top 20 with highest max rating (active)</a></td>
	</tr>
	<tr>
		<td><a href="stats/ratingrecord.html" class="statText">First to achieve the highest ratings</a></td>
	</tr>
	<tr class="titleLine">
		<td><span>Challenge</span></td>
	</tr>
	<tr>
		<td><a href="stats/chasucrate.html" class="statText">Top 20 challenge success rate</a></td>
	</tr>
	<tr>
		<td><a href="stats/chapointstotal.html" class="statText">Top 20 challenge points in total</a></td>
	</tr>
	<tr>
		<td><a href="stats/chapointsavg.html" class="statText">Top 20 challenge points in average</a></td>
	</tr>
	<tr>
		<td><a href="stats/chapointsin1event.html" class="statText">Top 20 challenge points in one event</a></td>
	</tr>
	<tr class="titleLine">
		<td><span>Misc</span></td>
	</tr>
	<tr>
		<td><a href="stats/sucrate.html" class="statText">Top 20 submission success rate</a></td>
	</tr>
	<tr>
		<td><a href="stats/mostevents.html" class="statText">Top 20 with most events</a></td>
	</tr>
	<tr>
		<td><a href="stats/mosteventslastyear.html" class="statText">Top 20 with most events in last year</a></td>
	</tr>
	<tr>
		<td><a href="stats/chameleons.html" class="statText">Top 20 chameleons</a></td>
	</tr>
	<tr>
		<td><a href="stats/volatile.html" class="statText">Top 20 most volatile</a></td>
	</tr>
	<tr class="titleLine">
		<td><span>List</span></td>
	</tr>
	<tr>
		<td><a href="stats/divwinners.html" class="statText">All division winners</a></td>
	</tr>
	<tr>
		<td><a href="stats/onsite.html" class="statText">All onsite ZJUers</a></td>
	</tr>
	<tr>
		<td><a href="stats/zjuers.html" class="statText">All ZJUers (with at least one event)</a></td>
	</tr>
</tbody></table></div>
<table border="0" cellspacing="0" cellpadding="0" class="anounce"><tbody>
	<tr class="anounceLine">
		<td><span>Developed by <a href="http://www.topcoder.com/tc?module=MemberProfile&cr=22645364" class="hhanger">hhanger</a></span></td>
	</tr>
</tbody></table>
</div>
</div>
END

ROUND_TABLE_HEADER = <<END
	<tr class="titleLine">
		<td><span>Rank</span></td>
		<td><span>Handle</span></td>
		<td><span>Points</span></td>
		<td><span>Level 1</span></td>
		<td><span>Level 2</span></td>
		<td><span>Level 3</span></td>
		<td><span>Challenge</span></td>
		<td><span>Challenge Points</span></td>
		<td><span>Old Rating</span></td>
		<td><span>New Rating</span></td>
		<td><span>Rating Change</span></td>
		<td><span>Volatility</span></td>
	</tr>
END

def round_table_header(tour)
  <<END
	<tr class="titleLine">
		<td><span>Rank</span></td>
		<td><span>Handle</span></td>
		<td><span>Points</span></td>
#{tour ? "<td><span>Advanced</span></td>" : ""}
		<td><span>Level 1</span></td>
		<td><span>Level 2</span></td>
		<td><span>Level 3</span></td>
		<td><span>Challenge</span></td>
		<td><span>Challenge Points</span></td>
		<td><span>Old Rating</span></td>
		<td><span>New Rating</span></td>
		<td><span>Rating Change</span></td>
		<td><span>Volatility</span></td>
	</tr>
END
end
