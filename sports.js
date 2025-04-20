document.addEventListener("DOMContentLoaded", async () => {
    const productList = document.querySelector('.product-list');
    const addProductForm = document.getElementById('addProductForm');
    const updateProductForm = document.getElementById('updateProductForm');
    const addProductModal = document.getElementById('addProductModal');
    const updateProductModal = document.getElementById('updateProductModal');
    const closeModalBtn = document.getElementById('closeModal');
    const closeUpdateModalBtn = document.getElementById('closeUpdateModal');
    const addProductBtn = document.getElementById('addProductBtn');

    // Set category as 'sports' for all operations
    const category = "sports";

    // Show Add Product Modal
    addProductBtn.addEventListener('click', () => {
        addProductModal.style.display = 'block';
    });

    // Close Add Product Modal
    closeModalBtn.addEventListener('click', () => {
        addProductModal.style.display = 'none';
        addProductForm.reset();
    });

    // Close Update Product Modal
    closeUpdateModalBtn.addEventListener('click', () => {
        updateProductModal.style.display = 'none';
        updateProductForm.reset();
    });

    // Fetch Sports Products Function
    async function fetchSportsProducts() {
        try {
            const response = await fetch('http://localhost:3000/api/sports');
            const products = await response.json();

            productList.innerHTML = '';

            if (products.length === 0) {
                productList.innerHTML = "<p>No sports products found.</p>";
            }

            products.forEach(product => {
                const productCard = `
                    <div class="product-card">
                        <img src="${product.productImage}" alt="${product.productName}">
                        <h3>${product.productName}</h3>
                        <p>$${product.productPrice}</p>
                        <button onclick="viewProduct('${product._id}', '${product.productName}', '${product.productPrice}', '${product.productImage}')">Update</button>
                        <button onclick="deleteProduct('${product._id}')">Delete</button>
                    </div>
                `;
                productList.innerHTML += productCard;
            });
        } catch (err) {
            console.error('Failed to fetch sports products:', err);
        }
    }

    // View & Update Sports Product
    window.viewProduct = (id, name, price, image) => {
        updateProductModal.style.display = 'block';
        document.getElementById('updateProductId').value = id;
        document.getElementById('updateProductName').value = name;
        document.getElementById('updateProductPrice').value = price;
        document.getElementById('updateProductImage').value = image;
    };

    // Form Submit to Update Sports Product
    updateProductForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const productId = document.getElementById('updateProductId').value;
        const productName = document.getElementById('updateProductName').value;
        const productPrice = document.getElementById('updateProductPrice').value;
        const productImage = document.getElementById('updateProductImage').value;

        const product = { productName, productPrice, productImage };

        try {
            await fetch(`http://localhost:3000/api/sports/${productId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(product),
            });

            alert('Sports Product Updated Successfully');
            fetchSportsProducts();
            updateProductModal.style.display = 'none';
            updateProductForm.reset();
        } catch (err) {
            console.error(err);
            alert('Failed to Update Sports Product');
        }
    });

    // Delete Sports Product
    window.deleteProduct = async (id) => {
        if (confirm('Are you sure you want to delete this sports product?')) {
            try {
                await fetch(`http://localhost:3000/api/sports/${id}`, {
                    method: 'DELETE',
                });

                alert('Sports Product Deleted Successfully');
                fetchSportsProducts();
            } catch (err) {
                console.error(err);
                alert('Failed to Delete Sports Product');
            }
        }
    };

    // Form Submit to Add Sports Product
    addProductForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const productName = document.getElementById('productName').value;
        const productPrice = document.getElementById('productPrice').value;
        const productImage = document.getElementById('productImage').value;

        const product = {
            productName,
            productPrice,
            productImage,
            category,
        };

        try {
            await fetch('http://localhost:3000/api/sports', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(product),
            });

            alert('Sports Product Added Successfully');
            addProductModal.style.display = 'none';
            addProductForm.reset();
            fetchSportsProducts();
        } catch (err) {
            console.error(err);
            alert('Failed to Add Sports Product');
        }
    });

    // Load Sports Products on Page Load
    fetchSportsProducts();
});
