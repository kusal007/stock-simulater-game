<%
    HttpSession s = request.getSession();
    String un = null;
    if (s.getAttribute("us") != null) {
        un = s.getAttribute("us").toString();
    }
    if (un == null) {
        response.sendRedirect("/PROJECT_STOCK/index.jsp");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Hello Bulma!</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.1/css/bulma.min.css">
        <link rel="stylesheet" href="css/w3.css">
        <script defer src="https://use.fontawesome.com/releases/v5.0.7/js/all.js"></script>
        <!--FOR CHART-->
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js"></script>
        <link rel="stylesheet" href="css/common.css">
        <script src="http://www.chartjs.org/dist/2.7.2/Chart.bundle.js"></script>
        <script src="http://www.chartjs.org/samples/latest/utils.js"></script>
        <!-- FOR CHART -->

    </head>
    <body> 

        <!--MENU--> 

        <div class="w3-bar w3-orange">
            <a href="#" class="w3-bar-item w3-button w3-padding-large w3-hover-blue">Home</a>
            <a href="#" class="w3-bar-item w3-button w3-padding-large w3-hover-blue">Link 1</a>
            <a href="#" class="w3-bar-item w3-button w3-padding-large w3-hover-blue">Link 2</a>
        </div>
        <br/>
        <div class="w3-row">
            <div class="w3-col s2 w3-padding-large">
                <aside class="menu">
                    <p class="menu-label">
                        General
                    </p>

                    <ul class="menu-list">
                        <li><a>Dashboard</a></li>
                        <li><a>Customers</a></li>
                    </ul>
                    <p class="menu-label">
                        Transactions
                    </p>
                    <ul class="menu-list">
                        <li><a>Payments</a></li>
                        <li><a>Transfers</a></li>
                        <li><a>Balance</a></li>
                        <button id="h" onclick="addDT();">Add Data</button>
                    </ul>

                </aside>
            </div>

            <!--MENU-->

            <div class="w3-col s8 w3-centered">
                <button id="randomizeData">Randomize Data</button>
                <button id="addDataset">Add Dataset</button>
                <button id="removeDataset">Remove Dataset</button>
                <button id="addData">Add Data</button>
                <button id="removeData">Remove Data</button>
                <!-- CHART-->

                <canvas id="canvas" width="100%" height="60" onload="setTimeout(addDT(); , 3000)"></canvas>
                <script>

                    var MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
                    var config = {
                        type: 'line',
                        data: {
                            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                            datasets: [{
                                    label: 'My First dataset',
                                    backgroundColor: window.chartColors.red,
                                    borderColor: window.chartColors.red,
                                    data: [
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor()
                                    ],
                                    fill: false,
                                }, {
                                    label: 'My Second dataset',
                                    fill: false,
                                    backgroundColor: window.chartColors.blue,
                                    borderColor: window.chartColors.blue,
                                    data: [
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor(),
                                        randomScalingFactor()
                                    ],
                                }]
                        },
                        options: {
                            responsive: true,
                            title: {
                                display: true,
                                text: 'Chart.js Line Chart'
                            },
                            tooltips: {
                                mode: 'index',
                                intersect: false,
                            },
                            hover: {
                                mode: 'nearest',
                                intersect: true
                            },
                            scales: {
                                xAxes: [{
                                        display: true,
                                        scaleLabel: {
                                            display: true,
                                            labelString: 'Month'
                                        }
                                    }],
                                yAxes: [{
                                        display: true,
                                        scaleLabel: {
                                            display: true,
                                            labelString: 'Value'
                                        }
                                    }]
                            }
                        }
                    };
                    window.onload = function () {
                        var ctx = document.getElementById('canvas').getContext('2d');
                        window.myLine = new Chart(ctx, config);
                        setInterval(addDT, 1000);
                    };
                    document.getElementById('randomizeData').addEventListener('click', function () {
                        config.data.datasets.forEach(function (dataset) {
                            dataset.data = dataset.data.map(function () {
                                return randomScalingFactor();
                            });
                        });
                        window.myLine.update();
                    });
                    var colorNames = Object.keys(window.chartColors);
                    document.getElementById('addDataset').addEventListener('click', function () {
                        var colorName = colorNames[config.data.datasets.length % colorNames.length];
                        var newColor = window.chartColors[colorName];
                        var newDataset = {
                            label: 'Dataset ' + config.data.datasets.length,
                            backgroundColor: newColor,
                            borderColor: newColor,
                            data: [],
                            fill: false
                        };
                        for (var index = 0; index < config.data.labels.length; ++index) {
                            newDataset.data.push(randomScalingFactor());
                        }

                        config.data.datasets.push(newDataset);
                        window.myLine.update();
                    });
                    document.getElementById('addData').addEventListener('click', function () {
                        if (config.data.datasets.length > 0) {
                            var month = MONTHS[config.data.labels.length % MONTHS.length];
                            config.data.labels.push(month);
                            config.data.datasets.forEach(function (dataset) {
                                dataset.data.push(randomScalingFactor());
                            });
                            config.data.labels.shift(); // remove the label first

                            config.data.datasets.forEach(function (dataset, datasetIndex) {
                                dataset.data.shift();
                            });
                            window.myLine.update();
                        }
                    });
                    document.getElementById('removeDataset').addEventListener('click', function () {
                        config.data.datasets.splice(0, 1);
                        window.myLine.update();
                    });
                    document.getElementById('removeData').addEventListener('click', function () {
                        config.data.labels.splice(-1, 1); // remove the label first

                        config.data.datasets.forEach(function (dataset) {
                            dataset.data.pop();
                        });
                        window.myLine.update();
                    });
                    function addDT() {
                        if (config.data.datasets.length > 0) {
                            var month = MONTHS[config.data.labels.length % MONTHS.length];
                            config.data.labels.push(month);
                            config.data.datasets.forEach(function (dataset) {
                                dataset.data.push(randomScalingFactor());
                            });
                            config.data.labels.shift(); // remove the label first

                            config.data.datasets.forEach(function (dataset, datasetIndex) {
                                dataset.data.shift();
                            });
                            window.myLine.update();
                        }
                    }
                </script>


                <!-- CHART-->

            </div>

            <div class="w3-col s2">

                <p style="font-size:14px; font-family:Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif;">Balance</p>
                <h2 style="margin-top:-5px; font-weight:600;">$ 500.00</h2>

                <input type="button" class="button_main" value="ADD CREDITS" style="background-color:#F44336; margin-left:5px; width:88%;"/>

                <hr style="width:92%; border-color:#CCC;"/>

                <div class="w3-panel w3-margin-right" style="background-color:#FFF3E0; border:#FB8C00 thin solid; border-radius:5px;">
                    <h3>Alert</h3>
                    <p style="padding-bottom:12px; font-size:12px;">Red often indicates a Red often indicates a Red often indicates a </p>
                </div> 


                <div class="w3-row w3-centered">
                    <div class="w3-col s6 w3-left">
                        <input type="button" class="button_main" value="BUY" style="background-color:#F44336; margin-left:5px;"/>
                    </div>

                    <div class="w3-col s6 w3-center">
                        <input type="button" class="button_main" value="SELL" style="background-color:#00C853; margin-right:25px;"/>
                    </div>
                </div>

            </div> 

        </div> 
    </body>
</html>