<svelte:head>
	<title>Scrolly</title>
	<meta name="description" content="Scrolly test" />
</svelte:head>

<script>
  import { onMount } from "svelte";
  import { select, line, curveMonotoneX, scaleLinear, scalePoint, axisBottom, axisLeft } from "d3";
  import * as d3 from "d3";
  // import maindata from '../../components/le_us_philly.json';

  let data = [{"year":1981,"le":72.1,"group":"Philadelphia"},{"year":1982,"le":72.5,"group":"Philadelphia"},{"year":1983,"le":72.6,"group":"Philadelphia"},{"year":1984,"le":72.7,"group":"Philadelphia"},{"year":1985,"le":72.7,"group":"Philadelphia"},{"year":1986,"le":72.7,"group":"Philadelphia"},{"year":1987,"le":72.9,"group":"Philadelphia"},{"year":1988,"le":72.9,"group":"Philadelphia"},{"year":1989,"le":73.1,"group":"Philadelphia"},{"year":1990,"le":73.4,"group":"Philadelphia"},{"year":1991,"le":73.5,"group":"Philadelphia"},{"year":1992,"le":73.8,"group":"Philadelphia"},{"year":1993,"le":73.5,"group":"Philadelphia"},{"year":1994,"le":73.7,"group":"Philadelphia"},{"year":1995,"le":73.8,"group":"Philadelphia"},{"year":1996,"le":74.1,"group":"Philadelphia"},{"year":1997,"le":74.5,"group":"Philadelphia"},{"year":1998,"le":74.7,"group":"Philadelphia"},{"year":1999,"le":74.7,"group":"Philadelphia"},{"year":2000,"le":74.7,"group":"Philadelphia"}];

  onMount(() => {
    // D3.js code
    const svg = select("#chart");

    // Set the dimensions and margins of the chart
    const margin = { top: 20, right: 30, bottom: 30, left: 60 };
    const width = +svg.attr("width") - margin.left - margin.right;
    const height = +svg.attr("height") - margin.top - margin.bottom;

    // Parse the year values as dates
    data.forEach(d => (d.year = new Date(d.year, 0, 1)));

    // Create scales
    const x = scalePoint()
      .domain(data.map(d => d.year))
      .range([margin.left, width - margin.right])
      .padding(0.5);

    const y = scaleLinear()
      .domain([70, 80])
      .range([height - margin.bottom, margin.top]);

    // Append line for US data points
    const lineGeneratorPhilly = line()
      .x(d => x(d.year))
      .y(d => y(d.le))
      .curve(curveMonotoneX);

    svg.append("path")
      .datum(data.filter(d => d.group === "Philadelphia"))
      .attr("fill", "none")
      .attr("stroke", "DarkRed")
      .attr("stroke-width", 3)
      .attr("d", lineGeneratorPhilly);

    // Append line for US data points
    const lineGeneratorUS = line()
      .x(d => x(d.year))
      .y(d => y(d.le))
      .curve(curveMonotoneX);

    svg.append("path")
      .datum(data.filter(d => d.group === "US"))
      .attr("fill", "none")
      .attr("stroke", "FireBrick")
      .attr("stroke-width", 3)
      .attr("d", lineGeneratorUS);

    // Append data points with tooltips
    svg.selectAll("circle")
      .data(data)
      .enter()
      .append("circle")
      .attr("cx", d => x(d.year))
      .attr("cy", d => y(d.le))
      .attr("r", 5)
      .attr("fill", "salmon")
      .append("title") // Add tooltip
      .text(d => `Year: ${d.year.getFullYear()}, LE: ${d.le}, place: ${d.group}`);

    // Append x-axis
    svg.append("g")
      .attr("transform", `translate(0,${height - margin.bottom})`)
      .call(axisBottom(x).tickFormat(d3.timeFormat("%Y")))
      .selectAll("text")
      .attr("transform", "rotate(-45)")
      .attr("x", -10)
      .attr("y", 10)
      .style("text-anchor", "end");

    // Append y-axis
    svg.append("g")
      .attr("transform", `translate(${margin.left},0)`)
      .call(axisLeft(y));
  });
</script>

<svg id="chart" width="800" height="600"></svg>
