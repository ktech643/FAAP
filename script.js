// FAAP Scan App - Advanced UI/UX Interactive System
// ================================================

document.addEventListener('DOMContentLoaded', function() {
    initializeNavigation();
    initializeFlowNavigation();
    initializeScreenNavigation();
    initializeOnboardingFlow();
    initializeInteractions();
    initializeAnimations();
});

// Navigation System
function initializeNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    const contentSections = document.querySelectorAll('.content-section');

    navItems.forEach(item => {
        item.addEventListener('click', function() {
            const targetSection = this.getAttribute('data-section');
            
            // Update active nav item
            navItems.forEach(nav => nav.classList.remove('active'));
            this.classList.add('active');
            
            // Update active content section
            contentSections.forEach(section => section.classList.remove('active'));
            const targetElement = document.getElementById(targetSection);
            if (targetElement) {
                targetElement.classList.add('active');
            }
        });
    });
}

// Flow Navigation System
function initializeFlowNavigation() {
    const flowNavItems = document.querySelectorAll('.flow-nav-item');
    const flowDiagrams = document.querySelectorAll('.flow-diagram');

    flowNavItems.forEach(item => {
        item.addEventListener('click', function() {
            const targetFlow = this.getAttribute('data-flow');
            
            // Update active nav item
            flowNavItems.forEach(nav => nav.classList.remove('active'));
            this.classList.add('active');
            
            // Update active flow diagram
            flowDiagrams.forEach(diagram => diagram.classList.remove('active'));
            const targetElement = document.getElementById(targetFlow + '-flow');
            if (targetElement) {
                targetElement.classList.add('active');
            }
        });
    });
}

// Screen Navigation System
function initializeScreenNavigation() {
    const screenNavItems = document.querySelectorAll('.screen-nav-item');
    const screenMockups = document.querySelectorAll('.screen-mockup');

    screenNavItems.forEach(item => {
        item.addEventListener('click', function() {
            const targetScreen = this.getAttribute('data-screen');
            
            // Update active nav item
            screenNavItems.forEach(nav => nav.classList.remove('active'));
            this.classList.add('active');
            
            // Update active screen mockup
            screenMockups.forEach(mockup => mockup.classList.remove('active'));
            const targetElement = document.getElementById(targetScreen + '-screen');
            if (targetElement) {
                targetElement.classList.add('active');
            }
        });
    });
}

// Onboarding Flow System
function initializeOnboardingFlow() {
    let currentStep = 1;
    const totalSteps = 5;
    
    const prevButton = document.getElementById('onboarding-prev');
    const nextButton = document.getElementById('onboarding-next');
    const steps = document.querySelectorAll('.onboarding-step');
    const indicators = document.querySelectorAll('.indicator');

    function updateStep(step) {
        // Update steps
        steps.forEach((stepEl, index) => {
            stepEl.classList.toggle('active', index + 1 === step);
        });
        
        // Update indicators
        indicators.forEach((indicator, index) => {
            indicator.classList.toggle('active', index + 1 === step);
        });
        
        // Update buttons
        prevButton.disabled = step === 1;
        nextButton.textContent = step === totalSteps ? 'Get Started' : 'Next';
        
        // Add subtle animation
        const activeStep = document.querySelector('.onboarding-step.active');
        if (activeStep) {
            activeStep.style.transform = 'scale(0.98)';
            setTimeout(() => {
                activeStep.style.transform = 'scale(1)';
            }, 100);
        }
    }

    if (prevButton && nextButton) {
        prevButton.addEventListener('click', function() {
            if (currentStep > 1) {
                currentStep--;
                updateStep(currentStep);
            }
        });

        nextButton.addEventListener('click', function() {
            if (currentStep < totalSteps) {
                currentStep++;
                updateStep(currentStep);
            } else {
                // Simulate completion
                showNotification('Onboarding completed! Welcome to FAAP Scan!', 'success');
            }
        });
    }
}

// Interactive Animations
function initializeInteractions() {
    // Initialize all interactive elements
    initializeRippleEffects();
    initializeLoadingButtons();
    initializeFavoriteButtons();
    initializeSwipeableCards();
    initializeExpandableCards();
}

// Ripple Effect System
function initializeRippleEffects() {
    const rippleButtons = document.querySelectorAll('.ripple-button');
    
    rippleButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            createRipple(e, this);
        });
    });
}

function createRipple(event, element) {
    const circle = document.createElement('span');
    const diameter = Math.max(element.clientWidth, element.clientHeight);
    const radius = diameter / 2;
    
    const rect = element.getBoundingClientRect();
    circle.style.width = circle.style.height = diameter + 'px';
    circle.style.left = event.clientX - rect.left - radius + 'px';
    circle.style.top = event.clientY - rect.top - radius + 'px';
    circle.classList.add('ripple');
    
    const rippleOverlay = element.querySelector('.ripple-overlay');
    if (rippleOverlay) {
        const existingRipple = rippleOverlay.querySelector('.ripple');
        if (existingRipple) {
            existingRipple.remove();
        }
        rippleOverlay.appendChild(circle);
    }
}

// Loading Button System
function initializeLoadingButtons() {
    const loadingButtons = document.querySelectorAll('.loading-button');
    
    loadingButtons.forEach(button => {
        button.addEventListener('click', function() {
            toggleLoadingState(this);
        });
    });
}

function toggleLoadingState(button) {
    const isLoading = button.classList.contains('loading');
    
    if (!isLoading) {
        button.classList.add('loading');
        
        // Simulate async operation
        setTimeout(() => {
            button.classList.remove('loading');
            showNotification('Action completed successfully!', 'success');
        }, 2000);
    }
}

// Favorite Button System
function initializeFavoriteButtons() {
    const favoriteButtons = document.querySelectorAll('.favorite-button');
    
    favoriteButtons.forEach(button => {
        button.addEventListener('click', function() {
            toggleFavorite(this);
        });
    });
}

function toggleFavorite(button) {
    const isFavorited = button.classList.contains('favorited');
    const text = button.querySelector('.favorite-text');
    
    button.classList.toggle('favorited');
    
    if (text) {
        text.textContent = isFavorited ? 'Add to Favorites' : 'Remove from Favorites';
    }
    
    // Show feedback
    const message = isFavorited ? 'Removed from favorites' : 'Added to favorites';
    showNotification(message, isFavorited ? 'info' : 'success');
}

// Swipeable Cards System
function initializeSwipeableCards() {
    const swipeableCards = document.querySelectorAll('.swipeable-card');
    
    swipeableCards.forEach(card => {
        let startX = 0;
        let currentX = 0;
        let isDragging = false;
        
        card.addEventListener('touchstart', handleTouchStart, { passive: true });
        card.addEventListener('touchmove', handleTouchMove, { passive: true });
        card.addEventListener('touchend', handleTouchEnd, { passive: true });
        
        card.addEventListener('mousedown', handleMouseStart);
        card.addEventListener('mousemove', handleMouseMove);
        card.addEventListener('mouseup', handleMouseEnd);
        card.addEventListener('mouseleave', handleMouseEnd);
        
        function handleTouchStart(e) {
            startX = e.touches[0].clientX;
            isDragging = true;
            card.classList.add('dragging');
        }
        
        function handleMouseStart(e) {
            startX = e.clientX;
            isDragging = true;
            card.classList.add('dragging');
            e.preventDefault();
        }
        
        function handleTouchMove(e) {
            if (!isDragging) return;
            currentX = e.touches[0].clientX;
            updateCardPosition();
        }
        
        function handleMouseMove(e) {
            if (!isDragging) return;
            currentX = e.clientX;
            updateCardPosition();
        }
        
        function updateCardPosition() {
            const deltaX = currentX - startX;
            const threshold = card.offsetWidth * 0.3;
            
            if (deltaX < 0 && Math.abs(deltaX) > 20) {
                const progress = Math.min(Math.abs(deltaX) / threshold, 1);
                card.querySelector('.card-content').style.transform = `translateX(${deltaX}px)`;
                card.querySelector('.swipe-actions').style.transform = `translateX(${100 - (progress * 100)}%)`;
            }
        }
        
        function handleTouchEnd(e) {
            handleEnd();
        }
        
        function handleMouseEnd(e) {
            handleEnd();
        }
        
        function handleEnd() {
            if (!isDragging) return;
            
            const deltaX = currentX - startX;
            const threshold = card.offsetWidth * 0.3;
            
            if (Math.abs(deltaX) > threshold) {
                // Show actions
                card.querySelector('.card-content').style.transform = `translateX(-${threshold}px)`;
                card.querySelector('.swipe-actions').style.transform = 'translateX(0)';
            } else {
                // Reset position
                card.querySelector('.card-content').style.transform = 'translateX(0)';
                card.querySelector('.swipe-actions').style.transform = 'translateX(100%)';
            }
            
            isDragging = false;
            currentX = 0;
            card.classList.remove('dragging');
        }
    });
}

// Expandable Cards System
function initializeExpandableCards() {
    const expandableCards = document.querySelectorAll('.expandable-card');
    
    expandableCards.forEach(card => {
        card.addEventListener('click', function() {
            toggleCardExpansion(this);
        });
    });
}

function toggleCardExpansion(card) {
    const isExpanded = card.classList.contains('expanded');
    card.classList.toggle('expanded');
    
    // Animate the expansion
    const expandedContent = card.querySelector('.card-expanded');
    if (expandedContent) {
        if (isExpanded) {
            expandedContent.style.maxHeight = '0px';
        } else {
            expandedContent.style.maxHeight = expandedContent.scrollHeight + 'px';
        }
    }
}

// Animation Triggers
function initializeAnimations() {
    // Initialize intersection observer for scroll animations
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate');
            }
        });
    }, {
        threshold: 0.1
    });
    
    // Observe animated elements
    const animatedElements = document.querySelectorAll('.journey-stage, .component-item, .demo-item');
    animatedElements.forEach(el => observer.observe(el));
}

// Scanning Animation Triggers
function triggerScanAnimation(button) {
    const scanDemo = button.closest('.scan-demo');
    const scanBeam = scanDemo.querySelector('.scan-beam');
    const detectionPulse = scanDemo.querySelector('.detection-pulse');
    
    // Reset animations
    scanBeam.classList.remove('active');
    detectionPulse.classList.remove('active');
    
    // Trigger scan beam
    setTimeout(() => {
        scanBeam.classList.add('active');
    }, 100);
    
    // Trigger detection pulse after scan completes
    setTimeout(() => {
        detectionPulse.classList.add('active');
        showNotification('Barcode detected successfully!', 'success');
    }, 1600);
}

function triggerProcessingAnimation(button) {
    const processingDemo = button.closest('.processing-demo');
    const spinner = processingDemo.querySelector('.processing-spinner');
    const text = processingDemo.querySelector('.processing-text');
    
    const messages = [
        'Analyzing ingredients...',
        'Checking additive database...',
        'Calculating health score...',
        'Analysis complete!'
    ];
    
    let messageIndex = 0;
    
    const interval = setInterval(() => {
        text.textContent = messages[messageIndex];
        messageIndex++;
        
        if (messageIndex >= messages.length) {
            clearInterval(interval);
            showNotification('Product analysis completed!', 'success');
        }
    }, 800);
}

function triggerSuccessAnimation(button) {
    const successDemo = button.closest('.success-demo');
    const checkmark = successDemo.querySelector('.success-checkmark');
    
    checkmark.classList.remove('animate');
    setTimeout(() => {
        checkmark.classList.add('animate');
    }, 100);
}

// Progress Ring Animation
function animateProgressRing(button) {
    const demo = button.closest('.progress-ring-demo');
    const ring = demo.querySelector('.progress-ring-fill');
    const valueEl = demo.querySelector('.progress-value');
    
    const targetProgress = 75;
    const circumference = 314;
    const targetOffset = circumference - (circumference * targetProgress / 100);
    
    // Animate the ring
    ring.style.strokeDashoffset = targetOffset;
    
    // Animate the counter
    animateCounter(valueEl, 0, targetProgress, 1500, '%');
}

// Bar Chart Animation
function animateBarChart(button) {
    const demo = button.closest('.bar-chart-demo');
    const bars = demo.querySelectorAll('.bar-fill');
    
    bars.forEach((bar, index) => {
        const barContainer = bar.parentElement;
        const height = barContainer.getAttribute('data-height');
        
        setTimeout(() => {
            bar.style.height = height + '%';
        }, index * 200);
    });
}

// Counter Animation
function animateCounters(button) {
    const demo = button.closest('.counter-demo');
    const counters = demo.querySelectorAll('.counter-value');
    
    counters.forEach(counter => {
        const target = parseInt(counter.getAttribute('data-target'));
        animateCounter(counter, 0, target, 2000);
    });
}

function animateCounter(element, start, end, duration, suffix = '') {
    const range = end - start;
    const increment = range / (duration / 16);
    let current = start;
    
    const timer = setInterval(() => {
        current += increment;
        
        if (current >= end) {
            current = end;
            clearInterval(timer);
        }
        
        element.textContent = Math.floor(current) + suffix;
    }, 16);
}

// Notification System
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="notification-icon fas ${getNotificationIcon(type)}"></i>
            <span class="notification-message">${message}</span>
            <button class="notification-close" onclick="closeNotification(this)">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;
    
    // Add styles if not already present
    if (!document.querySelector('#notification-styles')) {
        const styles = document.createElement('style');
        styles.id = 'notification-styles';
        styles.textContent = `
            .notification {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1060;
                max-width: 400px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                transform: translateX(100%);
                transition: transform 0.3s ease-in-out;
                border-left: 4px solid;
            }
            
            .notification-success { border-left-color: #4CAF50; }
            .notification-error { border-left-color: #F44336; }
            .notification-warning { border-left-color: #FF9800; }
            .notification-info { border-left-color: #2196F3; }
            
            .notification.show {
                transform: translateX(0);
            }
            
            .notification-content {
                display: flex;
                align-items: center;
                padding: 16px;
                gap: 12px;
            }
            
            .notification-icon {
                flex-shrink: 0;
                font-size: 18px;
            }
            
            .notification-success .notification-icon { color: #4CAF50; }
            .notification-error .notification-icon { color: #F44336; }
            .notification-warning .notification-icon { color: #FF9800; }
            .notification-info .notification-icon { color: #2196F3; }
            
            .notification-message {
                flex: 1;
                font-size: 14px;
                color: #333;
            }
            
            .notification-close {
                border: none;
                background: none;
                cursor: pointer;
                color: #666;
                padding: 4px;
            }
            
            .notification-close:hover {
                color: #333;
            }
        `;
        document.head.appendChild(styles);
    }
    
    document.body.appendChild(notification);
    
    // Trigger animation
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    // Auto remove
    setTimeout(() => {
        closeNotification(notification.querySelector('.notification-close'));
    }, 5000);
}

function getNotificationIcon(type) {
    switch (type) {
        case 'success': return 'fa-check-circle';
        case 'error': return 'fa-exclamation-circle';
        case 'warning': return 'fa-exclamation-triangle';
        default: return 'fa-info-circle';
    }
}

function closeNotification(button) {
    const notification = button.closest('.notification');
    notification.classList.remove('show');
    
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 300);
}

// Touch Event Handlers (Global)
let touchStartX = 0;
let touchStartY = 0;

function handleTouchStart(event) {
    touchStartX = event.touches[0].clientX;
    touchStartY = event.touches[0].clientY;
}

function handleTouchMove(event) {
    if (!touchStartX || !touchStartY) return;
    
    const touchEndX = event.touches[0].clientX;
    const touchEndY = event.touches[0].clientY;
    
    const deltaX = touchStartX - touchEndX;
    const deltaY = touchStartY - touchEndY;
    
    // Prevent default scrolling for horizontal swipes
    if (Math.abs(deltaX) > Math.abs(deltaY)) {
        event.preventDefault();
    }
}

function handleTouchEnd(event) {
    touchStartX = 0;
    touchStartY = 0;
}

// Keyboard Navigation
document.addEventListener('keydown', function(event) {
    // Handle keyboard navigation for accessibility
    switch (event.key) {
        case 'Tab':
            // Ensure proper tab navigation
            handleTabNavigation(event);
            break;
        case 'Escape':
            // Close any open modals or expanded elements
            closeAllExpandedElements();
            break;
        case 'Enter':
        case ' ':
            // Activate focused interactive elements
            handleActivation(event);
            break;
    }
});

function handleTabNavigation(event) {
    // Custom tab navigation logic for complex components
    const focusableElements = document.querySelectorAll(
        'button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
    );
    
    const focusedElement = document.activeElement;
    const focusedIndex = Array.from(focusableElements).indexOf(focusedElement);
    
    // Add visual focus indicators
    focusableElements.forEach(el => el.classList.remove('keyboard-focused'));
    if (focusedElement && focusableElements.includes(focusedElement)) {
        focusedElement.classList.add('keyboard-focused');
    }
}

function closeAllExpandedElements() {
    // Close expanded cards
    const expandedCards = document.querySelectorAll('.expandable-card.expanded');
    expandedCards.forEach(card => {
        card.classList.remove('expanded');
        const expandedContent = card.querySelector('.card-expanded');
        if (expandedContent) {
            expandedContent.style.maxHeight = '0px';
        }
    });
    
    // Reset swipeable cards
    const swipeableCards = document.querySelectorAll('.swipeable-card');
    swipeableCards.forEach(card => {
        card.querySelector('.card-content').style.transform = 'translateX(0)';
        card.querySelector('.swipe-actions').style.transform = 'translateX(100%)';
    });
}

function handleActivation(event) {
    const target = event.target;
    
    if (target.classList.contains('expandable-card') || target.closest('.expandable-card')) {
        event.preventDefault();
        const card = target.classList.contains('expandable-card') ? target : target.closest('.expandable-card');
        toggleCardExpansion(card);
    }
}

// Performance Monitoring
function initializePerformanceMonitoring() {
    if ('performance' in window) {
        // Monitor page load performance
        window.addEventListener('load', function() {
            setTimeout(function() {
                const perfData = performance.getEntriesByType('navigation')[0];
                console.log('Page Load Performance:', {
                    domContentLoaded: perfData.domContentLoadedEventEnd - perfData.domContentLoadedEventStart,
                    loadComplete: perfData.loadEventEnd - perfData.loadEventStart,
                    totalLoadTime: perfData.loadEventEnd - perfData.navigationStart
                });
            }, 0);
        });
        
        // Monitor animation performance
        let frameCount = 0;
        let startTime = performance.now();
        
        function monitorFPS() {
            frameCount++;
            const currentTime = performance.now();
            
            if (currentTime - startTime >= 1000) {
                const fps = frameCount;
                frameCount = 0;
                startTime = currentTime;
                
                // Log performance warnings
                if (fps < 30) {
                    console.warn('Low FPS detected:', fps);
                }
            }
            
            requestAnimationFrame(monitorFPS);
        }
        
        requestAnimationFrame(monitorFPS);
    }
}

// Initialize performance monitoring
initializePerformanceMonitoring();

// Accessibility Enhancements
function initializeAccessibility() {
    // Add ARIA labels and descriptions
    const interactiveElements = document.querySelectorAll('button, [role="button"], .clickable');
    
    interactiveElements.forEach(element => {
        if (!element.getAttribute('aria-label') && !element.getAttribute('aria-labelledby')) {
            const text = element.textContent.trim() || element.title || 'Interactive element';
            element.setAttribute('aria-label', text);
        }
    });
    
    // Enhance focus management
    document.addEventListener('focusin', function(event) {
        const target = event.target;
        target.classList.add('focus-visible');
    });
    
    document.addEventListener('focusout', function(event) {
        const target = event.target;
        target.classList.remove('focus-visible');
    });
    
    // Add skip links
    if (!document.querySelector('.skip-link')) {
        const skipLink = document.createElement('a');
        skipLink.className = 'skip-link';
        skipLink.href = '#main-content';
        skipLink.textContent = 'Skip to main content';
        skipLink.style.cssText = `
            position: absolute;
            top: -40px;
            left: 6px;
            background: #000;
            color: #fff;
            padding: 8px;
            text-decoration: none;
            z-index: 9999;
            border-radius: 4px;
        `;
        
        skipLink.addEventListener('focus', function() {
            this.style.top = '6px';
        });
        
        skipLink.addEventListener('blur', function() {
            this.style.top = '-40px';
        });
        
        document.body.insertBefore(skipLink, document.body.firstChild);
    }
}

// Initialize accessibility features
initializeAccessibility();

// Error Handling
window.addEventListener('error', function(event) {
    console.error('JavaScript Error:', event.error);
    showNotification('An unexpected error occurred. Please refresh the page.', 'error');
});

window.addEventListener('unhandledrejection', function(event) {
    console.error('Unhandled Promise Rejection:', event.reason);
    showNotification('A network error occurred. Please check your connection.', 'error');
});

// Service Worker Registration (for PWA capabilities)
if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('/sw.js')
            .then(function(registration) {
                console.log('ServiceWorker registration successful');
            })
            .catch(function(err) {
                console.log('ServiceWorker registration failed');
            });
    });
}

// Export functions for global access
window.FAAP = {
    createRipple,
    toggleLoadingState,
    toggleFavorite,
    toggleCardExpansion,
    triggerScanAnimation,
    triggerProcessingAnimation,
    triggerSuccessAnimation,
    animateProgressRing,
    animateBarChart,
    animateCounters,
    showNotification,
    closeNotification
};