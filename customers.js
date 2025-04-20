document.addEventListener("DOMContentLoaded", function() {
    const addButton = document.querySelector(".add-customer-btn");
    const tableBody = document.getElementById("customerTableBody");

    addButton.addEventListener("click", function() {
        const name = prompt("Enter Customer Name:");
        const email = prompt("Enter Customer Email:");
        const phone = prompt("Enter Customer Phone:");

        if (name && email && phone) {
            const newRow = `<tr>
                <td>${name}</td>
                <td>${email}</td>
                <td>${phone}</td>
                <td><button class="delete-btn">Delete</button></td>
            </tr>`;
            tableBody.innerHTML += newRow;
            addDeleteEvent();
        }
    });

    function addDeleteEvent() {
        document.querySelectorAll(".delete-btn").forEach(button => {
            button.onclick = function() {
                this.closest("tr").remove();
            };
        });
    }

    addDeleteEvent();
});
// Dropdown Toggle Function
function toggleDropdown(id) {
    const dropdown = document.getElementById(id);
    if (dropdown.style.display === "none" || dropdown.style.display === "") {
        dropdown.style.display = "block";
    } else {
        dropdown.style.display = "none";
    }
}

document.addEventListener("DOMContentLoaded", function () {
    // Fetch users from the server and populate the table
    function fetchUsers() {
        fetch('http://localhost:3000/api/users')  // Replace with your server URL
            .then(response => response.json())
            .then(data => {
                const users = data.users || [];
                const tableBody = document.getElementById("customerTableBody");
                tableBody.innerHTML = '';  // Clear any existing rows
                
                // Dynamically create table rows for each user
                users.forEach(user => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td>${user.phone}</td>
                        <td><button class="delete-btn" onclick="deleteUser('${user._id}')">Delete</button></td>
                    `;
                    tableBody.appendChild(row);
                });
            })
            .catch(error => {
                console.error('Error fetching users:', error);
            });
    }

    // Function to delete a user (You can create the corresponding API endpoint for this)
    function deleteUser(userId) {
        // Send a delete request to the server to remove the user
        fetch(`http://localhost:3000/api/users/${userId}`, {
            method: 'DELETE'
        })
        .then(response => response.json())
        .then(data => {
            alert('User deleted successfully');
            fetchUsers();  // Refresh the list after deletion
        })
        .catch(error => {
            console.error('Error deleting user:', error);
        });
    }

    // Call fetchUsers on page load to populate the table
    fetchUsers();
});
