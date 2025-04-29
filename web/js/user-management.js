// Modal functions
function openModal() {
    document.getElementById('createAccountModal').style.display = 'block';
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
}

function closeModal() {
    document.getElementById('createAccountModal').style.display = 'none';
    document.body.style.overflow = 'auto'; // Restore scrolling
    document.getElementById('createAccountForm').reset(); // Reset form
}

document.addEventListener('DOMContentLoaded', function() {
    // Close modal when clicking outside of it
    window.onclick = function(event) {
        const modal = document.getElementById('createAccountModal');
        if (event.target == modal) {
            closeModal();
        }
    };
    
    // Show loading overlay on form submission
    const createAccountForm = document.getElementById('createAccountForm');
    if (createAccountForm) {
        createAccountForm.addEventListener('submit', function(e) {
            const roleCheckboxes = document.querySelectorAll('input[name="roleIds"]:checked');
            if (roleCheckboxes.length === 0) {
                e.preventDefault();
                alert('Please select at least one role for the user.');
                return false;
            }
            
            document.getElementById('loadingOverlay').style.display = 'flex';
        });
    }
    
    // Handle escape key to close modal
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && document.getElementById('createAccountModal').style.display === 'block') {
            closeModal();
        }
    });

    // Make sure the modal functions are available globally
    window.openModal = openModal;
    window.closeModal = closeModal;
});
