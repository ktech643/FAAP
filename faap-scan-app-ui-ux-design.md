# FAAP Scan App - Comprehensive UI/UX Design Specification

## 1. Design System Architecture

### 1.1 Design Tokens System

```yaml
# Core Design Tokens
tokens:
  colors:
    primary:
      green: 
        main: "#2E7D32"
        light: "#4CAF50"
        dark: "#1B5E20"
        contrast: "#FFFFFF"
      blue:
        main: "#1976D2"
        light: "#42A5F5"
        dark: "#0D47A1"
        contrast: "#FFFFFF"
    
    semantic:
      danger:
        main: "#D32F2F"
        light: "#EF5350"
        dark: "#B71C1C"
      warning:
        main: "#FBC02D"
        light: "#FFD54F"
        dark: "#F57F17"
      success:
        main: "#388E3C"
        light: "#66BB6A"
        dark: "#1B5E20"
      info:
        main: "#0288D1"
        light: "#29B6F6"
        dark: "#01579B"
    
    neutral:
      white: "#FFFFFF"
      gray:
        50: "#FAFAFA"
        100: "#F5F5F5"
        200: "#EEEEEE"
        300: "#E0E0E0"
        400: "#BDBDBD"
        500: "#9E9E9E"
        600: "#757575"
        700: "#616161"
        800: "#424242"
        900: "#212121"
      black: "#000000"
  
  typography:
    fontFamily:
      primary: "'Inter', -apple-system, BlinkMacSystemFont, sans-serif"
      secondary: "'Roboto Mono', 'Courier New', monospace"
    
    fontSize:
      h1: "32px"
      h2: "28px"
      h3: "24px"
      h4: "20px"
      h5: "18px"
      body-lg: "16px"
      body: "14px"
      body-sm: "12px"
      caption: "10px"
    
    fontWeight:
      light: 300
      regular: 400
      medium: 500
      semibold: 600
      bold: 700
    
    lineHeight:
      tight: 1.2
      normal: 1.5
      relaxed: 1.75
      loose: 2
  
  spacing:
    xs: "4px"
    sm: "8px"
    md: "16px"
    lg: "24px"
    xl: "32px"
    xxl: "48px"
  
  borderRadius:
    none: "0px"
    sm: "4px"
    md: "8px"
    lg: "12px"
    xl: "16px"
    full: "9999px"
  
  shadows:
    sm: "0 1px 2px 0 rgba(0, 0, 0, 0.05)"
    md: "0 4px 6px -1px rgba(0, 0, 0, 0.1)"
    lg: "0 10px 15px -3px rgba(0, 0, 0, 0.1)"
    xl: "0 20px 25px -5px rgba(0, 0, 0, 0.1)"
```

### 1.2 Component Library Structure

```
components/
├── atoms/
│   ├── Button/
│   ├── Icon/
│   ├── Typography/
│   ├── Input/
│   └── Badge/
├── molecules/
│   ├── Card/
│   ├── SearchBar/
│   ├── ProductItem/
│   ├── RiskIndicator/
│   └── NavigationItem/
├── organisms/
│   ├── Header/
│   ├── TabBar/
│   ├── ProductCard/
│   ├── ScanResult/
│   └── HealthChart/
└── templates/
    ├── MainLayout/
    ├── OnboardingLayout/
    ├── ResultsLayout/
    └── DashboardLayout/
```

## 2. Screen Specifications

### 2.1 Splash Screen
```
┌─────────────────────────┐
│         Status Bar      │
├─────────────────────────┤
│                         │
│                         │
│      [App Logo]         │
│                         │
│    "FAAP Scan"          │
│  "Scan. Know. Choose."  │
│                         │
│                         │
│    [Loading Bar]        │
│                         │
└─────────────────────────┘

Components:
- Logo: 120x120px, animated fade-in
- App Name: H1, Primary Green
- Tagline: Body-lg, Gray 600
- Loading Bar: 200px width, 4px height
```

### 2.2 Onboarding Screens

#### Screen 1: Welcome
```
┌─────────────────────────┐
│         Status Bar      │
├─────────────────────────┤
│                         │
│   [Illustration]        │
│                         │
│   "Welcome to           │
│    Healthier Choices"   │
│                         │
│   "Scan products to     │
│    discover harmful     │
│    additives"           │
│                         │
│   [Skip]    [Next →]    │
└─────────────────────────┘
```

#### Screen 2: Permissions
```
┌─────────────────────────┐
│         Status Bar      │
├─────────────────────────┤
│                         │
│   [Camera Icon]         │
│                         │
│   "Camera Access"       │
│                         │
│   "We need camera       │
│    access to scan       │
│    product barcodes"    │
│                         │
│   [Allow Camera]        │
│                         │
│   [Notification Icon]   │
│                         │
│   "Stay Informed"       │
│                         │
│   [Enable Notifications]│
│                         │
└─────────────────────────┘
```

### 2.3 Home Dashboard
```
┌─────────────────────────┐
│    FAAP Scan    [👤]    │
├─────────────────────────┤
│  Hello, [Username]! 👋  │
│                         │
│  ┌───────────────────┐  │
│  │  Health Score: 78  │  │
│  │  [Progress Ring]   │  │
│  └───────────────────┘  │
│                         │
│  Quick Actions          │
│  ┌─────┐ ┌─────┐       │
│  │ 📸  │ │ 🔍  │       │
│  │Scan │ │Search│       │
│  └─────┘ └─────┘       │
│                         │
│  Recent Scans           │
│  ┌───────────────────┐  │
│  │ [Product Card 1]  │  │
│  └───────────────────┘  │
│  ┌───────────────────┐  │
│  │ [Product Card 2]  │  │
│  └───────────────────┘  │
│                         │
├─────────────────────────┤
│  [🏠] [📊] [📚] [👤]   │
└─────────────────────────┘
```

### 2.4 Scanning Interface
```
┌─────────────────────────┐
│    [←] Scan Product     │
├─────────────────────────┤
│                         │
│   ┌─────────────────┐   │
│   │                 │   │
│   │  [Camera View]  │   │
│   │                 │   │
│   │   ┌─────────┐   │   │
│   │   │         │   │   │
│   │   │ [Focus] │   │   │
│   │   │  Frame  │   │   │
│   │   └─────────┘   │   │
│   │                 │   │
│   └─────────────────┘   │
│                         │
│  "Align barcode within  │
│   the frame"            │
│                         │
│  [💡] [Manual Entry]    │
│                         │
└─────────────────────────┘
```

### 2.5 Results Screen
```
┌─────────────────────────┐
│   [←] Scan Results      │
├─────────────────────────┤
│  ┌───────────────────┐  │
│  │  [Product Image]  │  │
│  └───────────────────┘  │
│                         │
│  Product Name           │
│  Brand Name             │
│                         │
│  Risk Assessment: HIGH  │
│  ████████████░░ 85%     │
│                         │
│  ⚠️ Harmful Additives   │
│  ┌───────────────────┐  │
│  │ E621 - MSG        │  │
│  │ Risk: High 🔴     │  │
│  └───────────────────┘  │
│  ┌───────────────────┐  │
│  │ E211 - Benzoate   │  │
│  │ Risk: Medium 🟡   │  │
│  └───────────────────┘  │
│                         │
│  [Find Alternatives]    │
│  [Save] [Share] [Report]│
└─────────────────────────┘
```

## 3. Interactive Elements

### 3.1 Button Specifications

#### Primary Button
```css
.button-primary {
  height: 48px;
  padding: 0 24px;
  background: #2E7D32;
  color: #FFFFFF;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  box-shadow: 0 4px 6px rgba(46, 125, 50, 0.2);
  transition: all 0.2s ease;
}

.button-primary:active {
  transform: scale(0.98);
  box-shadow: 0 2px 4px rgba(46, 125, 50, 0.2);
}
```

#### Secondary Button
```css
.button-secondary {
  height: 44px;
  padding: 0 20px;
  background: transparent;
  color: #2E7D32;
  border: 2px solid #2E7D32;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
}
```

### 3.2 Card Components

#### Product Card
```
┌─────────────────────────┐
│ ┌─────┐                 │
│ │ IMG │ Product Name    │
│ └─────┘ Brand           │
│         Risk: Medium 🟡  │
│         Scanned: 2h ago │
└─────────────────────────┘

Specs:
- Height: 80px
- Padding: 12px
- Border-radius: 12px
- Shadow: 0 2px 8px rgba(0,0,0,0.08)
```

### 3.3 Risk Indicators

```
Low Risk (Green):
[●●●○○] 0-30%
Color: #4CAF50

Medium Risk (Yellow):
[●●●●○] 31-60%
Color: #FBC02D

High Risk (Red):
[●●●●●] 61-100%
Color: #D32F2F
```

## 4. Microinteractions

### 4.1 Scan Animation
```
Frame 1: Circle expands (0ms)
Frame 2: Scanner line moves down (100ms)
Frame 3: Scanner line moves up (200ms)
Frame 4: Success pulse (300ms)
Frame 5: Check mark appears (400ms)
```

### 4.2 Loading States
```
Skeleton Loading:
┌─────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░         │
│ ░░░░░░░░░░░            │
└─────────────────────────┘

Shimmer effect: Linear gradient animation
Duration: 1.5s
Direction: Left to right
```

### 4.3 Haptic Feedback
- Success scan: Heavy impact
- Button press: Light impact
- Error: Medium impact pattern
- Swipe actions: Selection feedback

## 5. Navigation Patterns

### 5.1 Tab Bar Navigation
```
┌─────────────────────────┐
│                         │
│      Content Area       │
│                         │
├─────────────────────────┤
│  🏠   📊   📚   👤     │
│ Home Stats Learn Profile│
└─────────────────────────┘

Active state: Primary color + Label
Inactive: Gray 500
Height: 56px
```

### 5.2 Gesture Navigation
- Swipe right: Go back
- Swipe down: Refresh
- Long press: Context menu
- Pinch: Zoom product image
- Double tap: Quick scan

## 6. Accessibility Guidelines

### 6.1 Color Contrast
- Text on background: WCAG AAA (7:1)
- Interactive elements: WCAG AA (4.5:1)
- Focus indicators: 3px solid outline

### 6.2 Touch Targets
- Minimum size: 44x44px
- Spacing between targets: 8px minimum
- Error prevention: Confirmation for destructive actions

### 6.3 Screen Reader Support
```html
<!-- Example accessible button -->
<button 
  role="button"
  aria-label="Scan new product"
  aria-pressed="false"
>
  <Icon name="camera" aria-hidden="true" />
  <span>Scan</span>
</button>
```

## 7. Responsive Breakpoints

```css
/* Mobile First Approach */
/* Small devices (default) */
@media (min-width: 0px) {
  .container { padding: 16px; }
}

/* Medium devices */
@media (min-width: 375px) {
  .container { padding: 20px; }
}

/* Large devices */
@media (min-width: 414px) {
  .container { padding: 24px; }
}

/* Tablet support */
@media (min-width: 768px) {
  .container { 
    max-width: 600px;
    margin: 0 auto;
  }
}
```

## 8. Performance Optimization

### 8.1 Image Optimization
- Product images: WebP format, lazy loading
- Icons: SVG sprites
- Thumbnails: 80x80px, 2x resolution
- Max file size: 100KB per image

### 8.2 Animation Performance
```css
/* Use transform and opacity for animations */
.animate-slide {
  transform: translateX(0);
  opacity: 1;
  transition: transform 0.3s ease, opacity 0.3s ease;
  will-change: transform, opacity;
}
```

### 8.3 Code Splitting
```javascript
// Lazy load heavy features
const HealthDashboard = lazy(() => import('./HealthDashboard'));
const CommunityFeatures = lazy(() => import('./Community'));
const PremiumFeatures = lazy(() => import('./Premium'));
```

## 9. Dark Mode Support

```css
/* Light mode (default) */
:root {
  --bg-primary: #FFFFFF;
  --bg-secondary: #F5F5F5;
  --text-primary: #212121;
  --text-secondary: #757575;
}

/* Dark mode */
@media (prefers-color-scheme: dark) {
  :root {
    --bg-primary: #121212;
    --bg-secondary: #1E1E1E;
    --text-primary: #FFFFFF;
    --text-secondary: #B0B0B0;
  }
}
```

## 10. Error States & Empty States

### 10.1 Error State Design
```
┌─────────────────────────┐
│                         │
│      [Error Icon]       │
│                         │
│   "Oops! Something      │
│    went wrong"          │
│                         │
│   "We couldn't load     │
│    this product"        │
│                         │
│     [Try Again]         │
│                         │
└─────────────────────────┘
```

### 10.2 Empty State Design
```
┌─────────────────────────┐
│                         │
│   [Illustration]        │
│                         │
│   "No scans yet"        │
│                         │
│   "Start scanning       │
│    products to build    │
│    your history"        │
│                         │
│    [Start Scanning]     │
│                         │
└─────────────────────────┘
```

## 11. Platform-Specific Guidelines

### 11.1 iOS Design
- Use SF Symbols for icons
- Respect safe areas
- Support Dynamic Type
- Implement 3D Touch/Haptic Touch

### 11.2 Android Design
- Material Design 3 principles
- Support gesture navigation
- Implement Material You theming
- Edge-to-edge display

## 12. Metrics & Analytics

### 12.1 Key Performance Indicators
- Time to first scan: < 10 seconds
- Scan success rate: > 95%
- App launch time: < 2 seconds
- Crash-free rate: > 99.5%

### 12.2 User Engagement Metrics
- Daily active users
- Scans per session
- Feature adoption rate
- Premium conversion rate