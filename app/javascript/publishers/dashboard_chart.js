import Chart from 'chart.js';
import moment from 'moment';

let colors = [
  '255, 99, 132',
  '54, 162, 235',
  '255, 206, 86',
  '75, 192, 192',
  '153, 102, 255',
  '255, 159, 64'
]

function createLabels(startingDate) {
  var loop = new Date(startingDate);
  var dates_array = [];

  while (loop <= new Date()) {
    dates_array.push(loop.getFullYear() + '-' + (loop.getMonth() + 1) + '-' + loop.getDate());
    loop.setDate(loop.getDate() + 1);
  }

  return dates_array;
}

// Max of the chart is 80% of the suggested max to be used by Chartjs
function getSuggestedMax(data) {
  var currentMax = 0;
  Object.keys(data).forEach(function (key) {
    var value = data[key];
    currentMax = value.retrievals > currentMax ? value.retrievals : currentMax;
    currentMax = value.first_runs > currentMax ? value.first_runs : currentMax;
    currentMax = value.finalized > currentMax ? value.finalized : currentMax;
  });
  return (currentMax * 10 / 8)
}

function createCharts() {
  var data;
  JSON.parse(document.getElementById('referrals-hidden-tags').value).forEach(function (element) {
    data = JSON.parse(document.getElementById(element).value);
    createChart(
      data,
      element.replace(/-/g, " "),
      getSuggestedMax(data)
    );
  });
}

function createChart(data, title, suggestedMax) {
  var wrapper = document.getElementById('channel-referrals-stats-chart');
  var canvas = document.createElement('canvas');
  canvas.setAttribute("width", "400");
  canvas.setAttribute("height", "100");
  wrapper.appendChild(canvas);

  new Chart(canvas, {
    type: 'line',
    data: {
      labels: createLabels(data[0]['ymd']),
      datasets: [
        {
          label: 'Retrievals',
          data: data.map(x => x.retrievals),
          borderColor: '#F88469',
        },
        {
          label: 'First Runs',
          data: data.map(x => x.first_runs),
          borderColor: '#7B82E1',
        },
        {
          label: 'Finalized',
          data: data.map(x => x.finalized),
          borderColor: '#66C3FC',
        },
      ]
    },
    options: {
      tooltips: {
        mode: 'x'
      },
      title: {
        fontFamily: 'Poppins',
        fontSize: 18,
        display: true,
        text: title.toUpperCase()
      },
      scales: {
        yAxes: [{
          ticks: {
            suggestedMax: suggestedMax
          }
        }]
      }
    }
  });
}

document.addEventListener('DOMContentLoaded', function () {
  if (window.location.pathname === '/publishers/home') {
    createCharts();
  }
});