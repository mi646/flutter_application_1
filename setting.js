function updateProfile() {
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    alert(`Profile Updated!\nName: ${name}\nEmail: ${email}`);
}

function deleteAccount() {
    if (confirm("Are you sure you want to delete your account?")) {
        alert("Account Deleted Successfully!");
        window.location.href = 'dashboard.html';
    }
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