# FAAP Scan App - Figma Design Guidelines

## Design System Setup

### 1. Color Styles
```
Primary/Green: #2E7D32
Primary/Blue: #1976D2
Primary/Red: #D32F2F
Primary/Yellow: #FBC02D

Secondary/Success: #388E3C
Secondary/Warning: #F57C00
Secondary/Error: #D32F2F
Secondary/Info: #0288D1

Neutral/White: #FFFFFF
Neutral/Gray50: #FAFAFA
Neutral/Gray100: #F5F5F5
Neutral/Gray200: #EEEEEE
Neutral/Gray300: #E0E0E0
Neutral/Gray400: #BDBDBD
Neutral/Gray500: #9E9E9E
Neutral/Gray600: #757575
Neutral/Gray700: #616161
Neutral/Gray800: #424242
Neutral/Gray900: #212121
Neutral/Black: #000000
```

### 2. Typography Styles
```
Font: Inter

H1: 32px, Bold, -0.5 letter spacing
H2: 28px, Bold, -0.3 letter spacing
H3: 24px, SemiBold, -0.2 letter spacing
H4: 20px, SemiBold
H5: 18px, Medium
Body Large: 16px, Regular
Body: 14px, Regular
Body Small: 12px, Regular
Caption: 10px, Regular
```

### 3. Spacing & Grid
```
Base unit: 8px
- XXS: 2px
- XS: 4px
- SM: 8px
- MD: 12px
- LG: 16px
- XL: 24px
- XXL: 32px
- XXXL: 48px
```

### 4. Component Specifications

#### Buttons
- Primary Button: 44px height, 16px horizontal padding, 8px radius
- Icon size in buttons: 20px
- Text: 14px, SemiBold

#### Cards
- Border radius: 12px
- Padding: 16px
- Shadow: 0px 2px 8px rgba(0,0,0,0.08)

#### Input Fields
- Height: 48px
- Border: 1px solid #E0E0E0
- Focus border: 2px solid #1976D2
- Padding: 12px horizontal

#### Bottom Navigation
- Height: 64px
- Icon size: 24px
- Label: 10px
- Active color: #2E7D32
- Inactive color: #9E9E9E

## Screen Layouts (375x812px iPhone X/11)

### 1. Splash Screen
- Logo: 120x120px, centered
- App name: 36px, Bold
- Tagline: 16px, Regular
- Loading indicator: 20px

### 2. Onboarding Screens
- Illustration circle: 200x200px
- Title: 28px (H2)
- Description: 16px, 1.6 line height
- Page indicators: 8px height, 24px active width
- Navigation buttons: 44px height

### 3. Home Dashboard
- Header gradient: 200px height
- Scan hero card: Full width - 40px margin
- Health score widget: 80x80px circle
- Quick action cards: 2 column grid, 12px gap

### 4. Scan Screen
- Camera view: Full screen
- Scan overlay: 70% of screen width
- Corner markers: 40px length, 4px thickness
- Control buttons: 64x64px touch area

### 5. Results Screen
- Header: 260px expandable
- Risk icon: 64px
- Product card: Full width - 32px
- Additive items: 56px icon + content

### 6. Health Dashboard
- Score circle: 200x200px
- Stat cards: 2 column grid
- Charts: 200px height
- Insight cards: Full width

## Animation Specifications

### Transitions
- Navigation: 300ms ease-in-out
- Card hover: 100ms ease
- Loading: 2s infinite loop
- Score animation: 2s ease-in-out

### Micro-interactions
- Button press: Scale 0.95
- Card tap: Elevation increase
- Switch toggle: 200ms
- Progress bars: 800ms ease-out

## Export Settings

### Icons
- Format: SVG
- Size: 24x24px base
- Stroke: 2px
- Color: Inherit from parent

### Images
- Format: PNG
- Density: @1x, @2x, @3x
- Optimization: Compressed

### Assets Naming
- Icons: ic_[name]_[size]
- Images: img_[screen]_[description]
- Logos: logo_[variant]
- Backgrounds: bg_[screen]

## Prototype Interactions

### Navigation
- Tab bar: Instant transition
- Push: Slide from right
- Modal: Slide from bottom
- Back: Slide to right

### Gestures
- Swipe right: Back navigation
- Pull down: Refresh
- Long press: Context menu
- Pinch: Zoom images

## Handoff Specifications

### Developers Need:
1. Color hex values
2. Typography specifications
3. Spacing values
4. Border radius values
5. Shadow specifications
6. Animation duration/easing
7. Touch target sizes
8. Icon SVG exports

### Documentation Include:
1. User flows
2. Edge cases
3. Error states
4. Loading states
5. Empty states
6. Success states
7. Accessibility notes