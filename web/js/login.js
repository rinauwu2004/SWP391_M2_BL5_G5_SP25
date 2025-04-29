document.addEventListener('DOMContentLoaded', function() {
    // Auto hide error message after 5 seconds
    setTimeout(function() {
        const errorElement = document.getElementById('error');
        if (errorElement) {
            errorElement.style.display = 'none';
        }
    }, 5000);
});
