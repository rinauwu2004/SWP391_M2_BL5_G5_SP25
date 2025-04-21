document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const content = document.getElementById('content');
    const sidebarToggle = document.getElementById('sidebarToggle');
    
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('active');
            content.classList.toggle('active');
        });
    }
    
    // Handle responsive behavior
    function handleResize() {
        if (window.innerWidth <= 992) {
            sidebar.classList.remove('active');
            content.classList.remove('active');
        } else {
            sidebar.classList.add('active');
            content.classList.add('active');
        }
    }
    
    window.addEventListener('resize', handleResize);
    handleResize(); // Initial check
    
    // Auto hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.style.display = 'none';
        }, 5000);
    });
});
