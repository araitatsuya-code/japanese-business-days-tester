// Enhanced JavaScript for Japanese Business Days Tester

document.addEventListener('DOMContentLoaded', function() {
    const dateInput = document.getElementById('date');
    const dateForm = document.getElementById('dateForm');
    const submitBtn = document.getElementById('submitBtn');
    const validationHelp = document.getElementById('validationHelp');
    const dateError = document.getElementById('dateError');
    
    // Set default date to today
    if (dateInput) {
        const today = new Date().toISOString().split('T')[0];
        dateInput.value = today;
    }
    
    // Enhanced form validation
    if (dateForm) {
        // Real-time validation on input change
        dateInput.addEventListener('input', function() {
            validateDateInput();
        });
        
        // Show help on focus
        dateInput.addEventListener('focus', function() {
            if (validationHelp) {
                validationHelp.classList.remove('d-none');
            }
        });
        
        // Hide help on blur if valid
        dateInput.addEventListener('blur', function() {
            if (validationHelp && dateInput.value && validateDateInput()) {
                validationHelp.classList.add('d-none');
            }
        });
        
        // Form submission validation
        dateForm.addEventListener('submit', function(event) {
            if (!validateDateInput()) {
                event.preventDefault();
                event.stopPropagation();
                dateInput.classList.add('is-invalid');
                
                // Show specific error message
                if (!dateInput.value) {
                    dateError.textContent = '日付を選択してください';
                } else {
                    dateError.textContent = '有効な日付を入力してください';
                }
            } else {
                dateInput.classList.remove('is-invalid');
                dateInput.classList.add('is-valid');
                
                // Show loading state
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>チェック中...';
                submitBtn.disabled = true;
            }
        });
    }
    
    // Date validation function
    function validateDateInput() {
        if (!dateInput.value) {
            return false;
        }
        
        try {
            const inputDate = new Date(dateInput.value);
            const minDate = new Date('1900-01-01');
            const maxDate = new Date((new Date().getFullYear() + 10) + '-12-31');
            
            // Check if date is valid and within range
            if (isNaN(inputDate.getTime())) {
                return false;
            }
            
            if (inputDate < minDate || inputDate > maxDate) {
                dateError.textContent = `日付は1900年から${new Date().getFullYear() + 10}年の間で入力してください`;
                return false;
            }
            
            return true;
        } catch (e) {
            return false;
        }
    }
    
    // Add keyboard shortcuts
    document.addEventListener('keydown', function(event) {
        // Ctrl/Cmd + Enter to submit form
        if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
            if (dateForm && validateDateInput()) {
                dateForm.submit();
            }
        }
        
        // Escape to clear form
        if (event.key === 'Escape') {
            if (dateInput) {
                dateInput.value = '';
                dateInput.focus();
            }
        }
    });
    
    // Add today button functionality
    const todayBtn = document.getElementById('todayBtn');
    if (todayBtn) {
        todayBtn.addEventListener('click', function() {
            const today = new Date().toISOString().split('T')[0];
            dateInput.value = today;
            validateDateInput();
        });
    }
});