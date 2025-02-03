var config = {
    cUrl: 'https://api.spoonacular.com/food/products/search?query=',
    cKey: '7f74954148884415903f1ff5f409a47b'
};

let productSelect = document.querySelector('.productCategory');
let currentProductIndex = 0; // Track the current product index
let productsList = []; // Store the lists of products

function getProductDetails(){

    var query = productSelect.value;
    
    if (!query) {
        alert("Please select a product.");
        return;
    }

    fetch(`${config.cUrl}${query}&number=10&apiKey=${config.cKey}`)
    .then(response => {
        if (!response.ok) {
            throw new Error("Failed to fetch product data.");
        }
        return response.json();
    })
    .then(data => {
        // console.log(data);
        if (data.products.length > 0) {
            productsList = data.products; // Save the products Lists
            currentProductIndex = 0; // Reset to the first products
            displayProduct(currentProductIndex);
        } else {
            alert("No products found for the selected query.");
        }
    })
    .catch(err => {
        console.error(`An error occurred : ${err}`);
        alert(`An error occurred while fetching product details:`);
    });
}

function displayProduct(index){
    const product = productsList[index];
    document.getElementById("productDetails").style.display = "block";
    document.getElementById("productId").value = product.id;
    document.getElementById("productImage").src = product.image;
    document.getElementById("productName").value = product.title;
    document.getElementById("productDescription").textContent = product.title || "No description available.";
    document.getElementById("productPrice").textContent = `$${product.price || "Not available"}`;
}

//Event Listeners for Previous and Next Icons

document.querySelector('.fa-arrow-left').addEventListener('click', ()=>{
    if (currentProductIndex > 0) {
        currentProductIndex--;
        displayProduct(currentProductIndex);
    }else{
        alert("You're already viewing the first product."); 
    }
});

document.querySelector('.fa-arrow-right').addEventListener('click', () => {
    if(currentProductIndex < productsList.length - 1){
        currentProductIndex++;
        displayProduct(currentProductIndex);
    }else{
        alert("You're already viewing the last product."); 
    }
});