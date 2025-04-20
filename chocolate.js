document.addEventListener("DOMContentLoaded", async () => {
    const productList = document.querySelector('.product-list');
    const addProductForm = document.getElementById('addProductForm');
    const updateProductForm = document.getElementById('updateProductForm');
    const addProductModal = document.getElementById('addProductModal');
    const updateProductModal = document.getElementById('updateProductModal');
    const closeModalBtn = document.getElementById('closeModal');
    const closeUpdateModalBtn = document.getElementById('closeUpdateModal');
    const addProductBtn = document.getElementById('addProductBtn');
    const productImageInput = document.getElementById('productImage');
    const productImagePreview = document.getElementById('productImagePreview');
    const updateImageInput = document.getElementById('updateProductImage');
    const updateImagePreview = document.getElementById('updateProductImagePreview');

    const category = "chocolate";

    // Show Add Product Modal
    addProductBtn.addEventListener('click', () => {
        addProductModal.style.display = 'block';
    });

    // Close Add Product Modal
    closeModalBtn.addEventListener('click', () => {
        addProductModal.style.display = 'none';
        addProductForm.reset();
        productImagePreview.src = '';
    });

    // Close Update Product Modal
    closeUpdateModalBtn.addEventListener('click', () => {
        updateProductModal.style.display = 'none';
        updateProductForm.reset();
        updateImagePreview.src = '';
    });

    // Show add product image preview
    productImageInput.addEventListener('change', function () {
        const reader = new FileReader();
        reader.onload = function (e) {
            productImagePreview.src = e.target.result;
        };
        reader.readAsDataURL(this.files[0]);
    });

    // Show update product image preview
    updateImageInput.addEventListener('change', function () {
        const reader = new FileReader();
        reader.onload = function (e) {
            updateImagePreview.src = e.target.result;
        };
        if (this.files[0]) {
            reader.readAsDataURL(this.files[0]);
        }
    });

    // Fetch Chocolate Products Function
    async function fetchChocolateProducts() {
        try {
            const response = await fetch('http://localhost:3000/api/chocolate');
            const products = await response.json();

            productList.innerHTML = ''; // Clear list before appending

            if (products.length === 0) {
                productList.innerHTML = "<p>No chocolate products found.</p>";
            }

            products.forEach(product => {
                const productCard = `
                    <div class="product-card">
                        <img src="http://localhost:3000${product.productImage}" alt="${product.productName}">
                        <h3>${product.productName}</h3>
                        <p>$${product.productPrice}</p>
                        <button onclick="viewProduct('${product._id}', '${product.productName}', '${product.productPrice}', '${product.productImage}')">Update</button>
                        <button onclick="deleteProduct('${product._id}')">Delete</button>
                    </div>
                `;
                productList.innerHTML += productCard;
            });
        } catch (err) {
            console.error('Failed to fetch chocolate products:', err);
        }
    }

    // View & Update Chocolate Product
    window.viewProduct = (id, name, price, image) => {
        updateProductModal.style.display = 'block';
        document.getElementById('updateProductId').value = id;
        document.getElementById('updateProductName').value = name;
        document.getElementById('updateProductPrice').value = price;
        updateImagePreview.src = `http://localhost:3000${image}`;
    };

    // Add Product Submit
    addProductForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const formData = new FormData(addProductForm);
        formData.append("category", document.getElementById('category').value); // ✅ Correct category fetch

        try {
            await fetch('http://localhost:3000/api/chocolate', {
                method: 'POST',
                body: formData
            });

            alert('Chocolate Product Added Successfully');
            addProductModal.style.display = 'none';
            addProductForm.reset();
            productImagePreview.src = '';
            fetchChocolateProducts(); // Refresh Chocolate Products List
        } catch (err) {
            console.error(err);
            alert('Failed to Add Chocolate Product');
        }
    });

    // Delete Chocolate Product
    window.deleteProduct = async (id) => {
        if (confirm('Are you sure you want to delete this chocolate product?')) {
            try {
                await fetch(`http://localhost:3000/api/chocolate/${id}`, {
                    method: 'DELETE',
                });

                alert('Chocolate Product Deleted Successfully');
                fetchChocolateProducts();
            } catch (err) {
                console.error(err);
                alert('Failed to Delete Chocolate Product');
            }
        }
    };

    // Update Product Submit
    updateProductForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const id = document.getElementById('updateProductId').value;
        const formData = new FormData();

        // Get updated values
        const productName = document.getElementById('updateProductName').value;
        const productPrice = document.getElementById('updateProductPrice').value;
        const productImageFile = updateImageInput.files[0];

        // Append data
        formData.append("productName", productName);
        formData.append("productPrice", productPrice);
        if (productImageFile) {
            formData.append("productImage", productImageFile);
        }

        try {
            const response = await fetch(`http://localhost:3000/api/chocolate/${id}`, {
                method: 'PUT',
                body: formData
            });

            if (!response.ok) {
                const errMessage = await response.json();
                throw new Error(errMessage.message || 'Unknown Error');
            }

            alert('Chocolate Product Updated Successfully');
            updateProductModal.style.display = 'none';
            updateProductForm.reset();
            updateImagePreview.src = '';
            fetchChocolateProducts(); // Refresh
        } catch (err) {
            console.error('Update error:', err);
            alert(`Failed to Update Chocolate Product: ${err.message}`);
        }
    });

    // Initial Fetch of Products
    fetchChocolateProducts();
});
