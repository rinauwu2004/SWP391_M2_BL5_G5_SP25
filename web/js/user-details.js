document.addEventListener('DOMContentLoaded', function() {
    const editUserForm = document.getElementById('editUserForm');
    if (editUserForm) {
        editUserForm.addEventListener('submit', function(e) {
            const roleCheckboxes = document.querySelectorAll('input[name="roleIds"]:checked');
            if (roleCheckboxes.length === 0) {
                e.preventDefault();
                alert('Please select at least one role for the user.');
                return false;
            }
            
            document.getElementById('loadingOverlay').style.display = 'flex';
        });
    }
    
    const restrictedFields = [
        { id: 'username', label: 'Username' },
        { id: 'email', label: 'Email Address' },
        { id: 'phone', label: 'Phone Number' }
    ];
    
    const modal = document.getElementById('confirmEditModal');
    const modalText = document.getElementById('confirmModalText');
    const confirmBtn = document.getElementById('confirmEditBtn');
    const cancelBtn = document.getElementById('cancelEditBtn');
    
    let currentField = null;
    
    restrictedFields.forEach(field => {
        const fieldElement = document.getElementById(field.id);
        if (fieldElement) {
            fieldElement.addEventListener('click', function() {
                currentField = field.id;
                modalText.textContent = `Are you sure you want to edit the ${field.label}?`;
                modal.style.display = 'block';
            });
        }
    });
    
    if (cancelBtn) {
        cancelBtn.addEventListener('click', function() {
            modal.style.display = 'none';
            currentField = null;
        });
    }
    
    if (confirmBtn) {
        confirmBtn.addEventListener('click', function() {
            if (currentField) {
                const fieldElement = document.getElementById(currentField);
                fieldElement.readOnly = false;
                fieldElement.classList.remove('restricted-field');
                
                const icon = fieldElement.nextElementSibling;
                if (icon && icon.classList.contains('restricted-field-icon')) {
                    icon.style.display = 'none';
                }
                
                fieldElement.focus();
                
                modal.style.display = 'none';
                currentField = null;
            }
        });
    }
    
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            modal.style.display = 'none';
            currentField = null;
        }
    });
    
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && modal.style.display === 'block') {
            modal.style.display = 'none';
            currentField = null;
        }
    });
});
