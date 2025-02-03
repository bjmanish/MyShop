    //Form Validation code
    const registerButton = document.getElementById('registerButton');
    const errorMessage = document.getElementById('errorMessage');
    const successMessage = document.getElementById('successMessage');
    const registerForm = document.getElementById('registerForm');
    
    
    registerButton.addEventListener('click', () => {
        const profileImage = document.getElementById('profileImage').files[0];
        const username = document.getElementById('username').value.trim();
        const email = document.getElementById('email').value.trim();
        const pincode = document.getElementById('pincode').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        // Clear previous messages
        errorMessage.style.display = 'none';
        successMessage.style.display = 'none';

        // Email validation regex
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!username || !email || !password || !confirmPassword || !profileImage || !pincode) {
            errorMessage.textContent = 'All fields are required.';
            errorMessage.style.display = 'block';
            return;
        }

        if (!emailRegex.test(email)) {
            errorMessage.textContent = 'Invalid email address.';
            errorMessage.style.display = 'block';
            return;
        }
        if (password !== confirmPassword) {
            errorMessage.textContent = 'Passwords do not match.';
            errorMessage.style.display = 'block';
            return;
        }
        if (password.length < 6) {
            errorMessage.textContent = 'Password must be at least 6 characters long.';
            errorMessage.style.display = 'block';
            return;
        }
         
         
        // Simulate a successful registration
        const success =  successMessage.textContent = 'Registration successful!';
        successMessage.style.display = 'block';
        
        // Set the form's action to the servlet endpoint and submit
        registerForm.action = './RegisterSrv';
        registerForm.method = 'POST';
        registerForm.enctype = 'multipart/form-data';
        
        // Uncomment this to automatically submit the form after showing the success message
        setTimeout(() => {
            registerForm.submit();
        }, 2000); // Optional: Delay for user to see success message
            
    });
    
    //Image Preview function
    function previewImage(event) {
        const file = event.target.files[0];
        const preview = document.getElementById('profilePreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = './images/default-profile.png'; // Default image if no file selected
        }
    }
    
    // Function to toggle visibility and icon
    function togglePasswordVisibility(inputId, toggleId) {
        const inputField = document.getElementById(inputId);
        const toggleIcon = document.getElementById(toggleId);
        toggleIcon.addEventListener('click', () => {
            // Toggle the input type
            const type = inputField.getAttribute('type') === 'password' ? 'text' : 'password';
            inputField.setAttribute('type', type);
            // Toggle the icon
            toggleIcon.innerHTML = 
            type === 'password'
                ? '<i class="glyphicon glyphicon-eye-open"></i>'
                : '<i class="fa glyphicon glyphicon-eye-close"></i>';
        });
    }
    // Apply toggle functionality to both fields
    togglePasswordVisibility('password', 'togglePassword');
    togglePasswordVisibility('confirmPassword', 'toggleConfPassword');