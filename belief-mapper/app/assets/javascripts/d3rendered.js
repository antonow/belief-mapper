var width = 960,
    height = 500

var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height);

var force = d3.layout.force()
    .gravity(.05)
    .distance(150)
    .charge(-100)
    .size([width, height]);

d3.json("/beliefs.json", function(error, json) {
  var edges = [];
    json.connections.forEach(function(e) {
    var sourceBelief = json.beliefs.filter(function(n) { return n.id === e.source; })[0],
    targetBelief = json.beliefs.filter(function(n) { return n.id === e.target; })[0];

    edges.push({source: sourceBelief, target: targetBelief, value: e.value});
    });

  force
      .nodes(json.beliefs)
      .links(edges)
      .start();

  var link = svg.selectAll(".link")
      .data(edges)
      .enter().append("line")
      .attr("class", "link")
      .style("stroke-width", function(d) { return d.value *5 ; });

  var node = svg.selectAll(".node")
      .data(json.beliefs)
      .enter().append("g")
      .attr("class", "node")
      .call(force.drag);

  node.append("circle")
      // .data(json.nodes)
      // .enter()
      .attr("x", -8)
      .attr("y", -8)
      .attr("r", function(d) { return (d.count + 1 )* 25; })
      .attr("width", 16)
      .attr("height", 16);

  node.append("text")
      .attr("dx", 12)
      .attr("dy", ".35em")
      .text(function(d) { return d.name });

  force.on("tick", function() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
  });
});