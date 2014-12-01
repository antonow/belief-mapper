

renderD3Web = function() {
  var maxNodes = 40;
  // var showFirst;
  // var hideEdges;

  // $("#max_nodes").mousemove(function () {
  //   $("#text").text($("#max_nodes").val());
  //   maxNodes = $("#max_nodes").val();
  //   console.log(maxNodes);
  //   showFirst(10);
  //   hideEdges(25);
  // });




  var width = 960,
    height = 600

  var svg = d3.select(".graph").append("svg")
    .attr("width", width)
    .attr("height", height);

  var force = d3.layout.force()
    .gravity(.5)
    .distance(350)
    .charge(-10)
    .size([width, height]);

  function toQuintile(value) {
    switch (true) {
      case value > 85:
        return "hsl(5, 90%, 50%)";
        break;
      case value > 65:
        return "hsl(10, 80%, 50%)";
        break;
      case value > 50:
        return "hsl(15, 70%, 50%)";
        break;
      case value > 35:
        return "hsl(20, 60%, 50%)";
        break;
      case value > 20:
        return "hsl(25, 50%, 50%)";
        break;
      case value > 5:
        return "hsl(30, 40%, 50%)";
        break;
      case value == -1:
        return "hsl(0, 0%, 50%)";
        break;
    }
  }

  d3.json("/beliefs.json", function(error, json) {
    var data = json.beliefs.filter(function(d) {return d.id < maxNodes;});
    console.log(data);
    var edges = [];
    json.connections.forEach(function(e) {
      var sourceBelief = json.beliefs.filter(function(n) {
          return n.id === e.source;
        })[0],
        targetBelief = json.beliefs.filter(function(n) {
          return n.id === e.target;
        })[0];

        edges.push({
          source: sourceBelief,
          target: targetBelief,
          value: e.value
        });

    });

    // showFirst = function showFirst(x) {
    //   debugger;
    //   var node = svg.selectAll(".node")
    //     .data(edges.filter(function(d) { return d.id < x; }))
    //     .attr("display", "none");
    // }

    // hideEdges = function(max) {
    //   var link = svg.selectAll(".link")
    //     .data(edges.filter(function(d) { return (d.source.id < max && d.target.id < max); }))
    //     .attr("display", "none");
    // }


    edges = edges.filter(function(d) { return (d.source.id < maxNodes && d.target.id < maxNodes); });

    force
      .nodes(json.beliefs)
      .links(edges)
      .start();

    var link = svg.selectAll(".link")
      .data(edges.filter(function(d) { return (d.source.id < maxNodes && d.target.id < maxNodes); }))
      .enter().append("line")
      .attr("class", "link")
      .style("opacity", function(d) {
        return d.value / 10;
      })
      .style("stroke-width", function(d) {
        if (d.value > 3) {
          return d.value;
        };
      });

    var node = svg.selectAll(".node")
      .data(json.beliefs.filter(function(d) {return d.id < maxNodes;}))
      .enter().append("g")
      .attr("class", "node")
      .call(force.drag);

    node.append("circle")
      // .data(json.nodes)
      // .enter()
      .attr("x", -8)
      .attr("y", -8)
      .attr("id", function(d) {
        return d.id;
      })
      .attr("def", function(d) {
        return d.definition;
      })
      .attr("r", function(d) {
        return d.count * 2;
      })
      // .style("fill", function(d) { return d.color;})    "hsl(" + d.hsl.to_quintile + ",50%, 50%)"; })
      .style("fill", function(d) {
        return toQuintile(d.hsl);
      })
      .attr("width", 16)
      .attr("height", 16);

    node.append("text")
      .attr("dx", 12)
      .attr("dy", ".35em")
      .style("fill", "#153D93")
      .text(function(d) {
        return d.name
      });

    node.on("click", function(d) {
      $('#selected_node').html(d.id);
      link.style('stroke-width', function(l) {
        if (d === l.source || d === l.target)
          return l.value;
        else
          return 0;
      })
      link.style('stroke', function(l) {
        if (d === l.source || d === l.target)
          return "#DA6E6C";
        else
          return "#ccc";
      });
    });

    node.on("dblclick", function(d) {
      link.style('stroke-width', function(l) {
        return l.value;
      })
      link.style('stroke', '#ccc');
    });

    $('.node').tipsy({
      gravity: 'sw',
      html: true,
      title: function() {
        var def = this.getElementsByTagName("circle")[0].getAttribute("def");
        return def;
      }
    });

    // d3.selectAll("circle").on("click", function(){
    //           // d3.select(this).attr('r', 25)
    //             d3.select(this).style("fill","lightcoral")
    //               .style("stroke","red");
    //       });

    var padding = 10, // separation between circles
      radius = 10;

    function collide(alpha) {
      var quadtree = d3.geom.quadtree(json.beliefs);
      return function(d) {
        // console.log("COLLIDE RETURN!", d);
        //console.log(quadtree);
        var rb = 2 * radius + padding,
          nx1 = d.x - rb,
          nx2 = d.x + rb,
          ny1 = d.y - rb,
          ny2 = d.y + rb;
        quadtree.visit(function(quad, x1, y1, x2, y2) {
          //console.log("VISITED!!!!!", quad);
          if (quad.point && (quad.point !== d)) {
            var x = d.x - quad.point.x,
              y = d.y - quad.point.y,
              l = Math.sqrt(x * x + y * y);
            if (l < rb) {
              l = (l - rb) / l * alpha;
              d.x -= x *= l;
              d.y -= y *= l;
              quad.point.x += x;
              quad.point.y += y;
            }
          }
          return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
        });
      };
    }

    force.on("tick", function() {

      link.attr("x1", function(d) {
          return d.source.x;
        })
        .attr("y1", function(d) {
          return d.source.y;
        })
        .attr("x2", function(d) {
          return d.target.x;
        })
        .attr("y2", function(d) {
          return d.target.y;
        });

      node.attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      });
      // node.each(collide(1));

    });

  });
}
