document.addEventListener("DOMContentLoaded", async () => {
    const productList = document.querySelector('.product-list');
    const addProductForm = document.getElementById('addProductForm');
    const updateProductForm = document.getElementById('updateProductForm');
    const addProductModal = document.getElementById('addProductModal');
    const updateProductModal = document.getElementById('updateProductModal');
    const closeModalBtn = document.getElementById('closeModal');
    const closeUpdateModalBtn = document.getElementById('closeUpdateModal');
    const addProductBtn = document.getElementById('addProductBtn');

    // Set category as 'toys' for all operations
    const category = "toys";

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

    // Fetch Toys Products Function
    async function fetchToysProducts() {
        try {
            const response = await fetch('http://localhost:3000/api/toys');
            const products = await response.json();

            productList.innerHTML = '';

            if (products.length === 0) {
                productList.innerHTML = "<p>No toys products found.</p>";
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
            console.error('Failed to fetch toys products:', err);
        }
    }

    // View & Update Toy Product
    window.viewProduct = (id, name, price, image) => {
        updateProductModal.style.display = 'block';
        document.getElementById('updateProductId').value = id;
        document.getElementById('updateProductName').value = name;
        document.getElementById('updateProductPrice').value = price;
        document.getElementById('updateProductImage').value = image;
    };

    // Form Submit to Update Toy Product
    updateProductForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const productId = document.getElementById('updateProductId').value;
        const productName = document.getElementById('updateProductName').value;
        const productPrice = document.getElementById('updateProductPrice').value;
        const productImage = document.getElementById('updateProductImage').value;

        const product = { productName, productPrice, productImage };

        try {
            await fetch(`http://localhost:3000/api/toys/${productId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(product),
            });

            alert('Toy Product Updated Successfully');
            fetchToysProducts();
            updateProductModal.style.display = 'none';
            updateProductForm.reset();
        } catch (err) {
            console.error(err);
            alert('Failed to Update Toy Product');
        }
    });

    // Delete Toy Product
    window.deleteProduct = async (id) => {
        if (confirm('Are you sure you want to delete this toy product?')) {
            try {
                await fetch(`http://localhost:3000/api/toys/${id}`, {
                    method: 'DELETE',
                });

                alert('Toy Product Deleted Successfully');
                fetchToysProducts();
            } catch (err) {
                console.error(err);
                alert('Failed to Delete Toy Product');
            }
        }
    };

    // Form Submit to Add Toy Product
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
            await fetch('http://localhost:3000/api/toys', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(product),
            });

            alert('Toy Product Added Successfully');
            addProductModal.style.display = 'none';
            addProductForm.reset();
            fetchToysProducts();
        } catch (err) {
            console.error(err);
            alert('Failed to Add Toy Product');
        }
    });

    // Load Toy Products on Page Load
    fetchToysProducts();
});
