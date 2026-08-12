$ErrorActionPreference = "Stop"

Write-Host "Preparing public project assets..." -ForegroundColor Cyan

New-Item -ItemType Directory -Force "public\images\projects" | Out-Null
New-Item -ItemType Directory -Force "public\interactive" | Out-Null

$downloads = @{
  "public\images\projects\mortgage-market-overview.png" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/mortgage-approval-analytics/main/visuals/MortgageMarketOverview.png"

  "public\images\projects\mortgage-property-income.png" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/mortgage-approval-analytics/main/visuals/PropertyIncomePatterns.png"

  "public\images\projects\mortgage-applicant-characteristics.png" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/mortgage-approval-analytics/main/visuals/ReportedApplicantCharacteristics.png"

  "public\images\projects\sql-retail-performance.png" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/sql_analytics/main/tableau/images/retail_performance_dashboard.png"

  "public\images\projects\sql-partner-pipeline.png" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/sql_analytics/main/tableau/images/partner_data_pipeline_dashboard.png"

  "public\images\projects\neo4j-correlation-network.png" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/neo4j-stock-network-analysis/main/visuals/correlation_network.png"

  "public\images\projects\neo4j-degree-vs-pagerank.png" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/neo4j-stock-network-analysis/main/visuals/degree_vs_pagerank.png"

  "public\images\projects\neo4j-threshold-sensitivity.png" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/neo4j-stock-network-analysis/main/visuals/threshold_sensitivity.png"

  "public\interactive\neo4j-stock-network.html" =
    "https://raw.githubusercontent.com/Ryan-Wenstrom-Portfolio/neo4j-stock-network-analysis/main/visuals/correlation_network_interactive.html"
}

foreach ($destination in $downloads.Keys) {
  Write-Host "Downloading $destination"
  Invoke-WebRequest -Uri $downloads[$destination] -OutFile $destination
}

# Improve the interactive Plotly network for portfolio use:
# responsive viewport, pan-first interaction, no box-zoom, slightly more
# spacing in the connected core, and accurate instructions.
$path = "public\interactive\neo4j-stock-network.html"
$html = Get-Content $path -Raw

$html = $html -replace `
  '<div style="height:850px; width:1500px;">', `
  '<div style="height:100vh; width:100vw; overflow:hidden;">'

$style = @'
<style id="portfolio-responsive-patch">
html,
body {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
  overflow: hidden;
  background: #ffffff;
}

.plotly-graph-div {
  width: 100% !important;
  height: 100% !important;
}
</style>
'@

$html = $html -replace '</head>', "$style`n</head>"

$script = @'
<script id="portfolio-interaction-patch">
window.addEventListener('load', async function () {
  const graph = document.querySelector('.plotly-graph-div');

  if (!graph || !window.Plotly) {
    return;
  }

  const xScale = 1.22;
  const yScale = 1.20;

  const updatedData = graph.data.map((trace) => {
    const updatedTrace = { ...trace };
    const isEdgeTrace = trace.mode === 'lines';
    const isConnectedNodeTrace =
      trace.mode &&
      trace.mode.includes('markers') &&
      trace.name !== 'Isolated Stock';

    if (
      (isEdgeTrace || isConnectedNodeTrace) &&
      Array.isArray(trace.x) &&
      Array.isArray(trace.y)
    ) {
      updatedTrace.x = trace.x.map((value) =>
        value === null || value === undefined ? value : value * xScale
      );

      updatedTrace.y = trace.y.map((value) =>
        value === null || value === undefined ? value : value * yScale
      );
    }

    return updatedTrace;
  });

  const annotations = Array.isArray(graph.layout.annotations)
    ? graph.layout.annotations.map((annotation) => {
        if (
          typeof annotation.text === 'string' &&
          annotation.text.includes('Hover over any stock')
        ) {
          return {
            ...annotation,
            text:
              'Hover over any stock for PageRank, degree, role, and network details. ' +
              'Click and drag to pan. Double-click to reset the view.'
          };
        }

        return annotation;
      })
    : graph.layout.annotations;

  const layout = {
    ...graph.layout,
    annotations,
    autosize: true,
    dragmode: 'pan'
  };

  delete layout.width;
  delete layout.height;

  await Plotly.react(
    graph,
    updatedData,
    layout,
    {
      responsive: true,
      scrollZoom: false,
      doubleClick: 'reset',
      displaylogo: false,
      displayModeBar: false
    }
  );

  Plotly.Plots.resize(graph);
});
</script>
'@

$html = $html -replace '</body>', "$script`n</body>"

$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText(
  (Resolve-Path $path),
  $html,
  $utf8
)

Write-Host ""
Write-Host "Assets ready." -ForegroundColor Green
Write-Host "Next: npm run build" -ForegroundColor Green
