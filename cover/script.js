$(function(){

	var width = 400, height = 600, max = 10000;
	
	// Rendering covers
	
	function pos(g) { return g.length == 0 ? 0 : g.shift() / 10000; }
	function num(g) { return g.length == 0 ? 0 : pos(g) * 2 - 1; }
	function integer(g,m) { return g.length == 0 ? 0 : g.shift() % m; }

	

	// Uses D3 to render a genome to an SVG element
	function render(svg, genome) {
		
		var renderers = [
		
			// Transform
			function(e,scale,g) {
				var s = pos(g) * 2;
				scale *= s;
				recurse(
					e.append("g").attr("transform","translate(" + num(g) + "," + num(g) + ")")
						.append("g").attr("transform","scale(" + s + "," + s + ")"), 
					scale, 
					g);
			},
			
			// Thicken line 		
			function(e,scale,g) {
				recurse(e, scale/2, g);
			},
			
			// Iterated transform 		
			function(e,scale,g) {
			
			
				var repeat = 1 + integer(g, 10), 
					x = num(g),
					y = num(g),
					s = pos(g) * 2, 
					r = pos(g) * 3.141592 * 2,
					left = g.length, 
					g2 = g;					
					
				while (repeat > 0) {
				
					if (scale < 1) break;
					
					g2 = g.slice(0);
					scale *= s;
					
					e = e.append("g").attr("transform","translate(" + x + "," + y + ")")
							.append("g").attr("transform","scale(" + s + ")")
							.append("g").attr("transform","rotate(" + r + ")");
					
					recurse(e, scale, g2);
					
					--repeat;
				}
			
				while (g2.length < g.length) g.shift();
			
			},
			
			// Bezier curve
			function(e,scale,g) {			
				e.append("path").attr({
					stroke: "black",
					fill: "none",
					'stroke-width': 1/scale,
					d: [ "M", num(g), num(g), "q", num(g), num(g), num(g), num(g) ].join(" ")
				});
			}
		
		];
		
		function recurse(e, scale, genome) {
		
			if (genome.length == 0) return;
			if (++count > 2000) return;
			renderers[genome.shift() % renderers.length](e, scale, genome); 
			
		}
		
		var scale = height, count = 0; 
		
		var e = d3.select(svg)
			.append("g")
				.attr("transform", "translate(" + (width / 2) + "," + (height / 2) + ")")
			.append("g")
				.attr("transform", "scale(" + scale + "," + scale + ")");
		
		genome = genome.slice(0);
		
		while (genome.length > 0 && count < 2000) recurse(e, scale, genome);
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
	
	// Generating a brand new genome.
	function rand(n) { return Math.floor(Math.random() * n); }
	function randGenome() {
		var length = rand(500), genome = [];
		for (var i = 0; i < length; ++i) genome.push(rand(max));
		return genome;
	}
	
	var population = [];
	for (var i = 0; i < 20; ++i) population.push(randGenome());
	
	asyncMergesort(population, function(x) {
		console.log(x);
	});
		
});