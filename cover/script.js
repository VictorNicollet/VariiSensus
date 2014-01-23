$(function(){

	// Uses D3 to render a genome to an SVG element
	function render(svg, genome) {
		
		var width = 400, height = 600;
		
		d3.select(svg)
			.append("g")
				.attr("transform", "translate(" + (width / 2) + "," + (height / 2) + ")")
			.append('text').style({fill:'black'}).text(genome);

	}
	
	// Displays two genomes alongside each other for comparison, 
	// makes them clickable
	function compare(genomeA, genomeB, RETURN) {
	
		$('body').html('<svg id=A></svg><svg id=B></svg>');
		
		render($('#A')[0], genomeA);
		$('#A').click(function(){ $('body').html(''); RETURN(1); });
		
		render($('#B')[0], genomeB);
		$('#B').click(function(){ $('body').html(''); RETURN(-1); });			
	}

	// Asynchronous merge sort, sorts an array by asking the user to 
	// compare elements two-by-two. Guaranteed O(n log n) questions 
	// for a size n array.
	function asyncMergesort(genomes, RETURN) {
		
		if (genomes.length < 2) return RETURN(genomes); 
		
		var mid = Math.floor(genomes.length / 2),
			first = genomes.slice(0,mid),
			second = genomes.slice(mid);
		
		asyncMergesort(first, function(first){
		
			asyncMergesort(second, function(second){
			
				var result = [];
				merge(result, first, second, function() { RETURN(result); });
			
			});
		
		});
		
		function merge(into, a, b, RETURN) {
		
			if (a.length == 0) {
				into.push.apply(into,b)
				return RETURN();
			}
			
			if (b.length == 0) {
				into.push.apply(into,a);
				return RETURN();
			}
			
			compare(a[0], b[0], function(side) {
				if (side < 0) { into.push(b.shift()); }
				if (side > 0) { into.push(a.shift()); }
				merge(into, a, b, RETURN);
			});
		}
	}
	
	asyncMergesort([ 7, 2, 6, 1, 3, 4, 5, 9, 8 ], function(x) {
		console.log(x);
	});
});