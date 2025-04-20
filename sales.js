// ✅ Wait until the DOM is fully loaded
document.addEventListener("DOMContentLoaded", function () {
    // ✅ Handle category clicks in the sidebar dropdown
    const categories = document.querySelectorAll(".dropdown li");

    categories.forEach(item => {
        item.addEventListener("click", function () {
            window.location.href = `${item.getAttribute("data-page")}.html`;
        });
    });

    // ✅ Initialize Sales Chart using Chart.js
    const ctx = document.getElementById("salesChart").getContext("2d");

    // Create the initial chart instance
    const salesChart = new Chart(ctx, {
        type: "line",
        data: {
            labels: ["January", "February", "March", "April", "May", "June"],
            datasets: [{
                label: "Sales Overview",
                data: [0, 0, 0, 0, 0, 0],  // Initial data, will be updated later
                backgroundColor: "rgba(52, 152, 219, 0.2)",
                borderColor: "#3498db",
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: true,
                    position: "top"
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    // Function to fetch sales data and update the chart
    function updateSalesChart() {
        fetch('http://localhost:3000/api/sales')  // Replace with your server URL
            .then(response => response.json())
            .then(data => {
                const salesData = data.sales || [0, 0, 0, 0, 0, 0];  // Default to zero sales if no data is available

                // Update the chart data dynamically without recreating the chart
                salesChart.data.datasets[0].data = salesData;
                salesChart.update();  // Re-render the chart with updated data
            })
            .catch(error => {
                console.error('Error fetching sales data:', error);
                // If there's an error, update chart with default data
                salesChart.data.datasets[0].data = [0, 0, 0, 0, 0, 0];
                salesChart.update();
            });
    }

    // ✅ Call the function to fetch and update the chart on page load
    updateSalesChart();
});

// ✅ Open Sales Form Popup
function openSalesForm() {
    document.getElementById('salesForm').style.display = 'block';
    document.getElementById('overlay').style.display = 'block';
}

// ✅ Close Sales Form Popup
function closeSalesForm() {
    document.getElementById('salesForm').style.display = 'none';
    document.getElementById('overlay').style.display = 'none';
}

// ✅ Handle Form Submission to Add Sales
function addSales() {
    const newSales = parseFloat(document.getElementById('salesAmount').value);
    const salesMonth = document.getElementById('salesMonth').value;
    const salesCategory = document.getElementById('salesCategory').value;

    if (newSales && salesMonth && salesCategory) {
        // Get current sales value and update it
        const currentSales = parseFloat(
            document.getElementById('monthlySales').innerText.replace('$', '').replace(',', '')
        ) || 0;

        const updatedSales = currentSales + newSales;

        // Update the DOM with the new sales value
        document.getElementById('monthlySales').innerText = `$${updatedSales.toLocaleString()}`;

        // Send the sales data to the server
        fetch('http://localhost:3000/api/sales', {  // Replace with your actual server URL
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                salesAmount: newSales,
                salesMonth: salesMonth,
                salesCategory: salesCategory
            })
        })
        .then(response => response.json())
        .then(data => {
            // Check the response for success/failure
            if (data.success) {
                alert(`Added $${newSales} for ${salesMonth} in ${salesCategory}.`);
                closeSalesForm(); // Close the form
            } else {
                alert('Failed to add sales data.');
            }
        })
        .catch(error => {
            alert('Error connecting to server: ' + error.message);
        });

        // ✅ Reset the form after submission
        document.getElementById('salesAmount').value = '';
        document.getElementById('salesMonth').value = '';
        document.getElementById('salesCategory').value = '';

    } else {
        // ❌ Error Alert
        alert("Please fill in all fields correctly.");
    }
}

// ✅ Fetch and display total sales from the server
document.addEventListener("DOMContentLoaded", function () {
    // Fetch the total sales data when the page is loaded
    fetch('http://localhost:3000/api/sales/total')  // Replace with your actual server URL
        .then(response => response.json())
        .then(data => {
            if (data.totalSales !== undefined) {
                // Update the DOM with the fetched total sales value
                document.getElementById('monthlySales').innerText = `$${data.totalSales.toLocaleString()}`;
            } else {
                console.error('Failed to load total sales');
                document.getElementById('monthlySales').innerText = '$0';
            }
        })
        .catch(error => {
            console.error('Error fetching total sales:', error);
            document.getElementById('monthlySales').innerText = '$0';
        });
});

