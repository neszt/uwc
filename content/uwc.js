
process.stdin.setEncoding('utf8');
var stream = process.stdin.pipe(require('split')());
var hash = { };
var pattern = new RegExp("[a-z']+", "gi");

stream.on('data', function(line) {
		var matches = ('' + line).match(pattern);
		if (!matches)
			return;

		for (var i = 0; i < matches.length; ++i) {
			var w = matches[i];
			if (hash.hasOwnProperty(w)) {
				hash[w]++;
			} else {
				hash[w] = 1;
			}
		}
	});

stream.on('end', function() {
	var words = [];
	for (w in hash) {
		words.push(w);
	}
	words.sort(function(a, b) {
		var d = hash[a] - hash[b];
		if (d != 0)
			return d;

		if (a < b) {
			return -1;
		} else {
			return 1;
		}
	});

	for (var i = 0; i < words.length; ++i) {
		var w = words[i];
		process.stdout.write(w + " " + hash[w] + "\n");
	}
});
