document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const content = document.getElementById('content');
    const sidebarToggle = document.getElementById('sidebarToggle');
    
    sidebarToggle.addEventListener('click', function() {
        sidebar.classList.toggle('active');
        content.classList.toggle('active');
    });
    
    // Handle responsive behavior
    function handleResize() {
        if (window.innerWidth <= 768) {
            sidebar.classList.remove('active');
            content.classList.remove('active');
        } else {
            sidebar.classList.add('active');
            content.classList.add('active');
        }
    }
    
    window.addEventListener('resize', handleResize);
    handleResize(); // Initial check
});
