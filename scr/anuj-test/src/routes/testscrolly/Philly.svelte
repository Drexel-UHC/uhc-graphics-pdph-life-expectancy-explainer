<svelte:head>
	<title>Scrolly</title>
	<meta name="description" content="Scrolly test" />
</svelte:head>

<script>
  import { onMount, afterUpdate } from "svelte";
  import { select, line, curveMonotoneX, scaleLinear, scalePoint, axisBottom, axisLeft } from "d3";
  import { tweened } from 'svelte/motion';
  import { cubicOut } from 'svelte/easing';
  import * as d3 from "d3";
  // import maindata from '../../components/le_us_philly.json';

  let data = [{"year":1981,"le":72.1,"group":"Philadelphia"},{"year":1982,"le":72.5,"group":"Philadelphia"},{"year":1983,"le":72.6,"group":"Philadelphia"},{"year":1984,"le":72.7,"group":"Philadelphia"},{"year":1985,"le":72.7,"group":"Philadelphia"},{"year":1986,"le":72.7,"group":"Philadelphia"},{"year":1987,"le":72.9,"group":"Philadelphia"},{"year":1988,"le":72.9,"group":"Philadelphia"},{"year":1989,"le":73.1,"group":"Philadelphia"},{"year":1990,"le":73.4,"group":"Philadelphia"},{"year":1991,"le":73.5,"group":"Philadelphia"},{"year":1992,"le":73.8,"group":"Philadelphia"},{"year":1993,"le":73.5,"group":"Philadelphia"},{"year":1994,"le":73.7,"group":"Philadelphia"},{"year":1995,"le":73.8,"group":"Philadelphia"},{"year":1996,"le":74.1,"group":"Philadelphia"},{"year":1997,"le":74.5,"group":"Philadelphia"},{"year":1998,"le":74.7,"group":"Philadelphia"},{"year":1999,"le":74.7,"group":"Philadelphia"},{"year":2000,"le":74.7,"group":"Philadelphia"},{"year":2001,"le":74.7,"group":"Philadelphia"},{"year":2002,"le":74.7,"group":"Philadelphia"},{"year":2003,"le":74.7,"group":"Philadelphia"},{"year":2004,"le":74.7,"group":"Philadelphia"},{"year":2005,"le":74.7,"group":"Philadelphia"},{"year":2006,"le":74.7,"group":"Philadelphia"},{"year":2007,"le":74.7,"group":"Philadelphia"},{"year":2008,"le":74.7,"group":"Philadelphia"},{"year":2009,"le":74.7,"group":"Philadelphia"},{"year":2010,"le":74.6,"group":"Philadelphia"},{"year":2011,"le":74.5,"group":"Philadelphia"},{"year":2012,"le":74.4,"group":"Philadelphia"},{"year":2013,"le":74.3,"group":"Philadelphia"},{"year":2014,"le":74.2,"group":"Philadelphia"},{"year":2015,"le":74.1,"group":"Philadelphia"},{"year":2016,"le":74,"group":"Philadelphia"},{"year":2017,"le":73.9,"group":"Philadelphia"},{"year":2018,"le":73.8,"group":"Philadelphia"},{"year":1981,"le":74.1,"group":"US"},{"year":1982,"le":74.5,"group":"US"},{"year":1983,"le":74.6,"group":"US"},{"year":1984,"le":74.7,"group":"US"},{"year":1985,"le":74.7,"group":"US"},{"year":1986,"le":74.7,"group":"US"},{"year":1987,"le":74.9,"group":"US"},{"year":1988,"le":74.9,"group":"US"},{"year":1989,"le":75.1,"group":"US"},{"year":1990,"le":75.4,"group":"US"},{"year":1991,"le":75.5,"group":"US"},{"year":1992,"le":75.8,"group":"US"},{"year":1993,"le":75.5,"group":"US"},{"year":1994,"le":75.7,"group":"US"},{"year":1995,"le":75.8,"group":"US"},{"year":1996,"le":76.1,"group":"US"},{"year":1997,"le":76.5,"group":"US"},{"year":1998,"le":76.7,"group":"US"},{"year":1999,"le":76.7,"group":"US"},{"year":2000,"le":76.8,"group":"US"},{"year":2001,"le":77,"group":"US"},{"year":2002,"le":77,"group":"US"},{"year":2003,"le":77.6,"group":"US"},{"year":2004,"le":77.5,"group":"US"},{"year":2005,"le":77.6,"group":"US"},{"year":2006,"le":77.8,"group":"US"},{"year":2007,"le":78.1,"group":"US"},{"year":2008,"le":78.2,"group":"US"},{"year":2009,"le":78.5,"group":"US"},{"year":2010,"le":78.7,"group":"US"},{"year":2011,"le":78.7,"group":"US"},{"year":2012,"le":78.8,"group":"US"},{"year":2013,"le":78.8,"group":"US"},{"year":2014,"le":78.9,"group":"US"},{"year":2015,"le":78.7,"group":"US"},{"year":2016,"le":78.7,"group":"US"},{"year":2017,"le":78.6,"group":"US"},{"year":2018,"le":78.7,"group":"US"}];

  let currentGroupIndex = 0;
  const currentGroupIndexTweened = tweened(0, { duration: 500, easing: cubicOut });

  let previousGroupIndex = 0;
  let previousGroupIndexTweened = tweened(0, { duration: 0 });

  let animateLine = false;
  const animateLineTweened = tweened(0, { duration: 2000 });

  afterUpdate(() => {
    previousGroupIndex = currentGroupIndex;
    previousGroupIndexTweened.set(currentGroupIndex);
  });

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

    // Append line for Philadelphia data points
    const lineGeneratorPhilly = line()
      .x(d => x(d.year))
      .y(d => y(d.le))
      .curve(curveMonotoneX);

    svg.append("path")
      .datum(data.filter(d => d.group === "Philadelphia"))
      .attr("fill", "none")
      .attr("stroke", "DarkRed")
      .attr("stroke-width", 3)
      .attr("class", "philadelphia-line") // Add class for visibility control
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
      .attr("class", "us-line") // Add class for visibility control
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

    currentGroupIndexTweened.subscribe(value => {
      currentGroupIndex = Math.round(value);
      svg.select(".philadelphia-line")
        .attr("opacity", (currentGroupIndex === 0 ? 1 : 0));
      svg.select(".us-line")
        .attr("opacity", (currentGroupIndex === 1 ? 1 : 0));
    });

    animateLineTweened.subscribe(value => {
      animateLine = value > 0;
      if (animateLine) {
        const lineLength = svg.select(".us-line").node().getTotalLength();
        svg.select(".us-line")
          .attr("stroke-dasharray", lineLength + " " + lineLength)
          .attr("stroke-dashoffset", lineLength - value * lineLength);
        svg.select(".philadelphia-line")
          .attr("stroke-dasharray", lineLength + " " + lineLength)
          .attr("stroke-dashoffset", lineLength - value * lineLength);
      } else {
        svg.select(".us-line")
          .attr("stroke-dasharray", null)
          .attr("stroke-dashoffset", null);
        svg.select(".philadelphia-line")
          .attr("stroke-dasharray", null)
          .attr("stroke-dashoffset", null);
      }
    });
  });

  function handleScroll() {
    if (window.pageYOffset > 0) {
      currentGroupIndexTweened.set(1);
      animateLineTweened.set(1);
    } else {
      currentGroupIndexTweened.set(0);
      animateLineTweened.set(0);
    }
  }

  window.addEventListener("scroll", handleScroll);

  onMount(() => {
    window.addEventListener("scroll", handleScroll);
  });

  function onDestroy() {
    window.removeEventListener("scroll", handleScroll);
  }
</script>

<svg id="chart" width="800" height="600"></svg>
