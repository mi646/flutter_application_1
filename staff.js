document.getElementById("add-staff-btn").addEventListener("click", function() {
    let name = prompt("Enter Staff Name:");
    let role = prompt("Enter Staff Role:");
    let email = prompt("Enter Staff Email:");

    if (name && role && email) {
        let table = document.getElementById("staff-list");
        let row = table.insertRow();
        row.innerHTML = `<td>${name}</td><td>${role}</td><td>${email}</td><td><button onclick="deleteStaff(this)">❌ Delete</button></td>`;
    }
});

function deleteStaff(button) {
    let row = button.parentNode.parentNode;
    row.parentNode.removeChild(row);
}
// Dropdown Toggle Function
function toggleDropdown(id) {
    const dropdown = document.getElementById(id);
    if (dropdown.style.display === "none" || dropdown.style.display === "") {
        dropdown.style.display = "block";
    } else {
        dropdown.style.display = "none";
    }
}