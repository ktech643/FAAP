# FAAP Scan App - Detailed UI Mockups & Specifications

## Screen Mockups with Detailed Specifications

### 1. Splash Screen
```
╔═══════════════════════════════════════╗
║          Status Bar (System)          ║
╠═══════════════════════════════════════╣
║                                       ║
║                                       ║
║              ┌─────┐                  ║
║              │     │                  ║
║              │ 🍎  │                  ║
║              │     │                  ║
║              └─────┘                  ║
║                                       ║
║            FAAP SCAN                  ║
║        Scan. Know. Choose.            ║
║                                       ║
║                                       ║
║         ░░░░░░░░░░░░░░░░              ║
║         Loading...                    ║
║                                       ║
║                                       ║
╚═══════════════════════════════════════╝

Specifications:
- Background: Linear gradient (#2E7D32 to #1B5E20)
- Logo: 100x100px, white with subtle shadow
- App Name: Inter Bold, 28px, #FFFFFF
- Tagline: Inter Regular, 16px, #FFFFFF, 0.8 opacity
- Loading bar: 200px width, 4px height, #FFFFFF
- Animation: Logo fade in (0.5s), then text (0.3s)
```

### 2. Onboarding - Welcome Screen
```
╔═══════════════════════════════════════╗
║    Skip                         1/4   ║
╠═══════════════════════════════════════╣
║                                       ║
║         ┌───────────────┐             ║
║         │               │             ║
║         │  Illustration │             ║
║         │   (Healthy    │             ║
║         │   Shopping)   │             ║
║         │               │             ║
║         └───────────────┘             ║
║                                       ║
║      Welcome to Healthier             ║
║           Choices                     ║
║                                       ║
║   Scan products instantly to          ║
║   discover harmful additives          ║
║   and make informed decisions         ║
║                                       ║
║   ● ○ ○ ○                             ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │         NEXT →              │     ║
║   └─────────────────────────────┘     ║
║                                       ║
╚═══════════════════════════════════════╝

Specifications:
- Skip button: Gray 600, 14px, top-left
- Progress: "1/4" Gray 500, 14px, top-right
- Illustration: 280x200px, centered
- Title: Inter Bold, 24px, Gray 900, centered
- Description: Inter Regular, 16px, Gray 600, centered
- Dots: 8px diameter, Primary Green for active
- Next button: Primary Green, 48px height, full width - 32px
```

### 3. Home Dashboard
```
╔═══════════════════════════════════════╗
║   FAAP Scan              🔔  👤       ║
╠═══════════════════════════════════════╣
║                                       ║
║   Good morning, Sarah! 👋             ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │   Your Health Score         │     ║
║   │         ┌─────┐             │     ║
║   │         │ 78% │             │     ║
║   │         │ ⭕  │             │     ║
║   │         └─────┘             │     ║
║   │   Good · Improving ↑        │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Quick Actions                       ║
║   ┌──────────┐  ┌──────────┐         ║
║   │    📸    │  │    🔍    │         ║
║   │   Scan   │  │  Search  │         ║
║   └──────────┘  └──────────┘         ║
║                                       ║
║   Recent Scans                   See all║
║   ┌─────────────────────────────┐     ║
║   │ 🥤 Coca-Cola Original       │     ║
║   │    High Risk · 2 hours ago  │     ║
║   └─────────────────────────────┘     ║
║   ┌─────────────────────────────┐     ║
║   │ 🍕 Pizza Margherita         │     ║
║   │    Medium Risk · Yesterday  │     ║
║   └─────────────────────────────┘     ║
║                                       ║
╠═══════════════════════════════════════╣
║   🏠      📊      📚      👤          ║
║  Home   Stats   Learn  Profile        ║
╚═══════════════════════════════════════╝

Specifications:
- Header: White background, 56px height
- App name: Inter SemiBold, 20px, Primary Green
- Notification bell: Badge with count if > 0
- Health Score Card: 
  - Background: Linear gradient (light green)
  - Score: 48px, Bold, Primary Green
  - Progress ring: 120px diameter, 8px stroke
- Quick Action buttons: 
  - Size: 80x80px
  - Background: Gray 50
  - Icon: 32px, Primary color
  - Label: 14px, Gray 700
- Recent scan items:
  - Height: 72px
  - Padding: 16px
  - Border: 1px Gray 200
  - Risk indicator: Colored dot + text
```

### 4. Scanning Interface
```
╔═══════════════════════════════════════╗
║   ← Back      Scan Product            ║
╠═══════════════════════════════════════╣
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │                             │     ║
║   │                             │     ║
║   │      Camera Preview         │     ║
║   │                             │     ║
║   │    ┌─────────────────┐     │     ║
║   │    │                 │     │     ║
║   │    │   ─ ─ ─ ─ ─    │     │     ║
║   │    │  │         │    │     │     ║
║   │    │   ─ ─ ─ ─ ─    │     │     ║
║   │    │                 │     │     ║
║   │    └─────────────────┘     │     ║
║   │                             │     ║
║   │         📸                  │     ║
║   │                             │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Align barcode within frame          ║
║                                       ║
║   💡 Tips · Manual Entry              ║
║                                       ║
╚═══════════════════════════════════════╝

Specifications:
- Camera preview: Full width, 4:3 ratio
- Scan frame: 
  - Size: 240x120px
  - Border: 2px dashed white
  - Corner markers: 20px, 4px thick
  - Animation: Pulsing glow effect
- Instruction text: 16px, Gray 600, centered
- Bottom buttons: 
  - Tips: Icon + text, Gray 600
  - Manual entry: Text link, Primary Blue
```

### 5. Scan Results Screen
```
╔═══════════════════════════════════════╗
║   ← Back         Scan Results    ⋮    ║
╠═══════════════════════════════════════╣
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │                             │     ║
║   │     [Product Image]         │     ║
║   │                             │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Coca-Cola Original                  ║
║   The Coca-Cola Company               ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │  ⚠️  HIGH RISK              │     ║
║   │  ████████████░░ 85%         │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Harmful Additives Found (3)         ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │ E150d - Caramel Color IV    │     ║
║   │ 🔴 High Risk                │     ║
║   │ Potential carcinogen        │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │ E338 - Phosphoric Acid      │     ║
║   │ 🟡 Medium Risk              │     ║
║   │ May affect bone density     │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │    Find Alternatives        │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Save  ·  Share  ·  Report Issue     ║
║                                       ║
╚═══════════════════════════════════════╝

Specifications:
- Product image: 
  - Full width, 200px height
  - Object-fit: cover
  - Fallback: Generic product icon
- Product info:
  - Name: Inter SemiBold, 20px, Gray 900
  - Brand: Inter Regular, 16px, Gray 600
- Risk assessment card:
  - Background: Based on risk level
  - High: Red gradient
  - Medium: Yellow gradient  
  - Low: Green gradient
  - Progress bar: 8px height, rounded
- Additive cards:
  - Background: White
  - Border: 1px solid Gray 200
  - Shadow: 0 2px 4px rgba(0,0,0,0.05)
  - Risk indicator: Colored circle + text
- Primary CTA: Full width - 32px, Primary color
- Secondary actions: Text buttons, centered
```

### 6. Health Dashboard
```
╔═══════════════════════════════════════╗
║   Health Tracking          Filter ▼   ║
╠═══════════════════════════════════════╣
║                                       ║
║   This Week's Summary                 ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │     Additive Exposure       │     ║
║   │                             │     ║
║   │  60  ┌─┐                   │     ║
║   │  40  │█│ ┌─┐               │     ║
║   │  20  │█│ │█│ ┌─┐ ┌─┐       │     ║
║   │   0  └─┘ └─┘ └─┘ └─┘       │     ║
║   │      M   T   W   T         │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Risk Distribution                   ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │        ┌───────┐            │     ║
║   │     ┌──┤       │            │     ║
║   │  45%│  │  25%  │ 30%       │     ║
║   │     └──┤       │            │     ║
║   │        └───────┘            │     ║
║   │  🔴 High  🟡 Med  🟢 Low    │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Top Consumed Additives              ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │ 1. E621 - MSG         12x  │     ║
║   │ 2. E150d - Caramel     8x  │     ║
║   │ 3. E211 - Benzoate     6x  │     ║
║   └─────────────────────────────┘     ║
║                                       ║
╠═══════════════════════════════════════╣
║   🏠      📊      📚      👤          ║
╚═══════════════════════════════════════╝

Specifications:
- Charts:
  - Bar chart: 280px width, 160px height
  - Animated on load
  - Touch to see details
  - Pie chart: 120px diameter
  - Donut style with 20px hole
- Cards:
  - Background: White
  - Border radius: 12px
  - Padding: 20px
  - Shadow: 0 2px 8px rgba(0,0,0,0.08)
- List items:
  - Height: 48px
  - Divider between items
  - Count badge on right
```

### 7. Search & Browse
```
╔═══════════════════════════════════════╗
║   Search                         ✕    ║
╠═══════════════════════════════════════╣
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │ 🔍 Search products...       │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Recent Searches                     ║
║   chips · cola · chocolate            ║
║                                       ║
║   Browse Categories                   ║
║                                       ║
║   ┌────────┐  ┌────────┐             ║
║   │   🥤   │  │   🍕   │             ║
║   │ Drinks │  │  Food  │             ║
║   └────────┘  └────────┘             ║
║                                       ║
║   ┌────────┐  ┌────────┐             ║
║   │   🍭   │  │   🧴   │             ║
║   │ Sweets │  │Personal│             ║
║   └────────┘  └────────┘             ║
║                                       ║
║   Popular Products                    ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │ 🥤 Pepsi Cola              │     ║
║   │    Medium Risk · Scan →     │     ║
║   └─────────────────────────────┘     ║
║                                       ║
╚═══════════════════════════════════════╝

Specifications:
- Search bar:
  - Height: 48px
  - Background: Gray 50
  - Border: 1px Gray 300 (2px Primary on focus)
  - Icon: 20px, Gray 500
- Recent searches:
  - Chips/pills style
  - Height: 32px
  - Background: Gray 100
  - Tap to search
- Category grid:
  - 2 columns
  - Card size: (width-48)/2
  - Height: 100px
  - Icon: 40px
  - Label: 14px, centered
```

### 8. Profile & Settings
```
╔═══════════════════════════════════════╗
║   Profile                      ⚙️     ║
╠═══════════════════════════════════════╣
║                                       ║
║          ┌─────────┐                  ║
║          │   👤    │                  ║
║          └─────────┘                  ║
║         Sarah Johnson                 ║
║      sarah.j@email.com                ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │  Premium Member 💎          │     ║
║   │  Member since Dec 2023      │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Your Stats                          ║
║   ┌─────────────────────────────┐     ║
║   │ 📊 Total Scans: 156        │     ║
║   │ 🏆 Healthy Choices: 89     │     ║
║   │ 📅 Active Days: 45         │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   Preferences                         ║
║                                       ║
║   Dietary Restrictions          >     ║
║   ─────────────────────────           ║
║   Allergen Alerts              >     ║
║   ─────────────────────────           ║
║   Notification Settings        >     ║
║   ─────────────────────────           ║
║   Privacy & Security           >     ║
║   ─────────────────────────           ║
║                                       ║
║   Help & Support               >     ║
║   About                        >     ║
║                                       ║
║   Sign Out                            ║
║                                       ║
╚═══════════════════════════════════════╝

Specifications:
- Avatar:
  - Size: 80px diameter
  - Border: 3px white + shadow
  - Centered
- User info:
  - Name: Inter SemiBold, 20px
  - Email: Inter Regular, 14px, Gray 600
- Premium badge:
  - Background: Premium gradient
  - Icon + text in white
  - Rounded corners
- Stats grid:
  - 3 items in row
  - Icon: 24px
  - Number: SemiBold, 18px
  - Label: Regular, 12px, Gray 600
- Menu items:
  - Height: 56px
  - Divider: 1px Gray 200
  - Chevron: Gray 400
  - Tap highlight: Gray 50
```

### 9. Premium Upsell Modal
```
╔═══════════════════════════════════════╗
║                    ✕                  ║
║                                       ║
║         ┌─────────┐                   ║
║         │   💎    │                   ║
║         └─────────┘                   ║
║                                       ║
║     Unlock Premium Features           ║
║                                       ║
║   ✓ Unlimited scans                  ║
║   ✓ Advanced health insights         ║
║   ✓ Personalized recommendations     ║
║   ✓ Ad-free experience               ║
║   ✓ Export reports                   ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │       $4.99/month           │     ║
║   │    Start Free Trial         │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │       $39.99/year           │     ║
║   │      Save 33% 🔥            │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║        Maybe Later                    ║
║                                       ║
╚═══════════════════════════════════════╝

Specifications:
- Modal:
  - Max width: 320px
  - Border radius: 16px
  - Shadow: 0 10px 40px rgba(0,0,0,0.2)
- Icon: 60px, gradient background
- Title: Inter Bold, 24px, centered
- Feature list:
  - Icon: ✓ in Primary Green
  - Text: 16px, Gray 700
  - Line height: 28px
- Price buttons:
  - Height: 56px
  - Primary: Gradient background
  - Price: Bold, 18px
  - Subtext: Regular, 14px
- Dismiss: Text button, Gray 600
```

### 10. Error States
```
╔═══════════════════════════════════════╗
║   ← Back         Error                ║
╠═══════════════════════════════════════╣
║                                       ║
║                                       ║
║         ┌─────────┐                   ║
║         │   😕    │                   ║
║         └─────────┘                   ║
║                                       ║
║     Product Not Found                 ║
║                                       ║
║   We couldn't find this product       ║
║   in our database                     ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │      Try Again              │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║   ┌─────────────────────────────┐     ║
║   │    Enter Manually           │     ║
║   └─────────────────────────────┘     ║
║                                       ║
║                                       ║
╚═══════════════════════════════════════╝

Specifications:
- Icon: 80px, grayscale
- Title: Inter SemiBold, 20px, Gray 900
- Description: Inter Regular, 16px, Gray 600
- Primary button: Standard primary style
- Secondary button: Outlined style
```

## Interactive Component States

### Button States
```
Default:        [  Button Text  ]
Hover:          [  Button Text  ] (Elevated shadow)
Pressed:        [  Button Text  ] (Scaled 0.98)
Disabled:       [  Button Text  ] (Opacity 0.5)
Loading:        [  ⟳ Loading... ]
```

### Input Field States
```
Default:        │ Placeholder text      │
                └───────────────────────┘

Focused:        │ User input│           │
                └───────────────────────┘
                  (Blue border)

Error:          │ Invalid input         │
                └───────────────────────┘
                ⚠️ Error message
                  (Red border)

Success:        │ Valid input ✓         │
                └───────────────────────┘
                  (Green border)
```

### Loading States
```
Skeleton:       ░░░░░░░░░░░░░░░░░░░
                ░░░░░░░░░░░░
                ░░░░░░░░

Spinner:        ⟳ (Rotating)

Progress:       ████████░░░░ 67%

Dots:           ● ● ● (Animated)
```

## Gesture Interactions

### Swipe Gestures
- **Right swipe**: Navigate back
- **Left swipe**: Delete item (with confirmation)
- **Down swipe**: Refresh content
- **Up swipe**: Load more content

### Touch Interactions
- **Tap**: Primary action
- **Long press**: Context menu
- **Double tap**: Quick action (like/favorite)
- **Pinch**: Zoom images
- **3D Touch**: Preview content

## Animation Specifications

### Page Transitions
```
Forward:  Current → [Slide left] → New
Back:     Current ← [Slide right] ← Previous
Modal:    Current ↑ [Slide up] ↑ Modal
```

### Micro-animations
```
Button tap:     Scale(0.98) → Scale(1.0)
                Duration: 100ms
                Easing: ease-out

Success:        Scale(0) → Scale(1.2) → Scale(1.0)
                Duration: 400ms
                Easing: spring

Loading:        Opacity(0) → Opacity(1)
                Duration: 200ms
                Easing: ease-in
```

## Platform-Specific Adaptations

### iOS Specific
- Safe area padding for notch devices
- iOS-style navigation gestures
- San Francisco font fallback
- Haptic feedback patterns

### Android Specific
- Material Design ripple effects
- Android-style back navigation
- Roboto font fallback
- System navigation bar handling