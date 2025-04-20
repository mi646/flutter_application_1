document.addEventListener("DOMContentLoaded", async () => {
    const notification = document.querySelector(".notification");
    const addProductBtn = document.querySelector(".add-product-btn");
    const productList = document.getElementById("product-list");

    // Function to add a new product card
    function addProductCard(name, price, imageUrl) {
        const card = document.createElement("div");
        card.classList.add("product-card");

        // Creating elements safely
        const img = document.createElement("img");
        img.src = imageUrl;
        img.alt = name;
        img.classList.add("product-image");

        const infoDiv = document.createElement("div");
        infoDiv.classList.add("product-info");

        const nameElem = document.createElement("h3");
        nameElem.classList.add("product-name");
        nameElem.textContent = name;

        const priceElem = document.createElement("p");
        priceElem.classList.add("product-price");
        priceElem.textContent = `$${parseFloat(price).toFixed(2)}`;

        const editBtn = document.createElement("button");
        editBtn.classList.add("edit-btn");
        editBtn.textContent = "✏️ Edit";

        const removeBtn = document.createElement("button");
        removeBtn.classList.add("remove-btn");
        removeBtn.textContent = "❌ Remove";

        // Remove Button Logic
        removeBtn.addEventListener("click", () => {
            card.remove();
        });

        // Edit Button Logic
        editBtn.addEventListener("click", () => {
            const newName = prompt("Enter the new product name:", name)?.trim();
            const newPrice = prompt("Enter the new product price:", price)?.trim();
            const newImage = prompt("Enter the new product image URL:", imageUrl)?.trim();

            if (newName && newPrice && newImage) {
                const parsedPrice = parseFloat(newPrice);
                if (!isNaN(parsedPrice) && parsedPrice > 0) {
                    nameElem.textContent = newName;
                    priceElem.textContent = `$${parsedPrice.toFixed(2)}`;
                    img.src = newImage;
                } else {
                    alert("Invalid price. Please enter a valid number.");
                }
            } else {
                alert("All fields are required.");
            }
        });

        // Append elements safely
        infoDiv.appendChild(nameElem);
        infoDiv.appendChild(priceElem);
        infoDiv.appendChild(editBtn);
        infoDiv.appendChild(removeBtn);
        card.appendChild(img);
        card.appendChild(infoDiv);

        productList.appendChild(card);
    }

    // Fetch Total Product Count
    async function fetchTotalProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/count');
            if (!response.ok) throw new Error("Failed to fetch product count");
            const data = await response.json();
            document.getElementById('total-products').textContent = data.count;
        } catch (err) {
            console.error(err);
            document.getElementById('total-products').textContent = "N/A";
        }
    }

    async function fetchTotalfashionProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/fashion/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('beauty-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching beauty product count:', error);
        }
    }
    
    async function fetchTotalchocolateProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/chocolate/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('chocolate-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching chocolate product count:', error);
        }
    }
    
    async function fetchTotalgroceryProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/grocery/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('grocery-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching grocery product count:', error);
        }
    }

    async function fetchTotaldecorationProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/decoration/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('decoration-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching decoration product count:', error);
        }
    }

    async function fetchTotalelectronicsProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/electronics/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('electronics-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching electronics product count:', error);
        }
    }

    async function fetchTotalfurnitureProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/furniture/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('furniture-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching furniture product count:', error);
        }
    }

    async function fetchTotalbooksProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/books/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('books-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching books product count:', error);
        }
    }

    async function fetchTotaltoysProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/toys/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('toys-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching toys product count:', error);
        }
    }

    async function fetchTotalsportsProductCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/sports/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('sports-products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching sports product count:', error);
        }
    }

    async function fetchTotalproductsCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/products/count');
            if (!response.ok) throw new Error("Failed to fetch products product count");
            const data = await response.json();
            document.getElementById('products').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching products count:', error);
        }
    }

    async function fetchTotalCustomerCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/users/count');
            if (!response.ok) throw new Error("Failed to fetch users product count");
            const data = await response.json();
            document.getElementById('users').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching users count:', error);
        }
    }

    async function fetchTotalbeautyCount() {
        try {
            const response = await fetch('http://localhost:3000/api/products/beauty/count');
            if (!response.ok) throw new Error("Failed to fetch beauty product count");
            const data = await response.json();
            document.getElementById('beauty').textContent = data.count; // Use your element ID
        } catch (error) {
            console.error('Error fetching beauty count:', error);
        }
    }
  // filepath: c:\Users\Owner\Downloads\dashboard ui kit (community)-html\dash.js



    // Fetch Category-wise Product Count
    async function fetchCategoryCounts() {
        try {
            const response = await fetch('http://localhost:3000/api/products/category-counts');
            if (!response.ok) throw new Error("Failed to fetch category counts");
            const data = await response.json();

            productList.innerHTML = ""; // Clear existing content

            data.categories.forEach(category => {
                const categoryCard = document.createElement("div");
                categoryCard.classList.add("category-card");

                const title = document.createElement("h3");
                title.textContent = category.category.charAt(0).toUpperCase() + category.category.slice(1);

                const count = document.createElement("p");
                count.textContent = `Products: ${category.count}`;

                const viewButton = document.createElement("button");
                viewButton.textContent = "View";
                viewButton.addEventListener("click", () => {
                    window.location.href = `${category.category}.html`;
                });

                categoryCard.appendChild(title);
                categoryCard.appendChild(count);
                categoryCard.appendChild(viewButton);

                productList.appendChild(categoryCard);
            });
        } catch (error) {
            console.error('Error fetching category counts:', error);
        }
    }

    // Load Data on Page Load
    await fetchTotalProductCount();
    await fetchTotalfashionProductCount();
    await fetchTotalchocolateProductCount();
    await fetchTotaldecorationProductCount();
    await fetchTotalelectronicsProductCount();
    await fetchTotalfurnitureProductCount();
    await fetchTotalbooksProductCount();
    await fetchTotaltoysProductCount();
    await fetchTotalsportsProductCount();
    await fetchTotalgroceryProductCount();
    await fetchTotalCustomerCount();
    await fetchTotalproductsCount();
    await fetchTotalbeautyCount();
    await fetchCategoryCounts();
   
});

// Dropdown Toggle Function
function toggleDropdown(id) {
    const dropdown = document.getElementById(id);
    dropdown.style.display = dropdown.style.display === "none" || dropdown.style.display === "" ? "block" : "none";
}
