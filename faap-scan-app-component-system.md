# FAAP Scan App - Component System Architecture

## Component Hierarchy Diagram

```mermaid
graph TB
    DS[Design System Foundation] --> DT[Design Tokens]
    
    DT --> C1[Colors]
    DT --> C2[Typography]
    DT --> C3[Spacing]
    DT --> C4[Shadows]
    DT --> C5[Border Radius]
    DT --> C6[Breakpoints]
    
    DS --> AT[Atoms]
    AT --> A1[Button]
    AT --> A2[Icon]
    AT --> A3[Text]
    AT --> A4[Input]
    AT --> A5[Badge]
    AT --> A6[Avatar]
    AT --> A7[Checkbox]
    AT --> A8[Radio]
    AT --> A9[Toggle]
    
    DS --> ML[Molecules]
    ML --> M1[Card]
    ML --> M2[List Item]
    ML --> M3[Search Bar]
    ML --> M4[Tab]
    ML --> M5[Notification]
    ML --> M6[Modal]
    ML --> M7[Toast]
    ML --> M8[Chip]
    ML --> M9[Progress Bar]
    
    DS --> OR[Organisms]
    OR --> O1[Header]
    OR --> O2[Navigation]
    OR --> O3[Product Card]
    OR --> O4[Scan Result]
    OR --> O5[Chart]
    OR --> O6[Form]
    OR --> O7[List]
    OR --> O8[Gallery]
    
    DS --> TM[Templates]
    TM --> T1[Main Layout]
    TM --> T2[Onboarding]
    TM --> T3[Dashboard]
    TM --> T4[Results]
    TM --> T5[Profile]
    
    DS --> PG[Pages]
    PG --> P1[Home]
    PG --> P2[Scan]
    PG --> P3[History]
    PG --> P4[Health]
    PG --> P5[Profile]

    style DS fill:#e3f2fd,stroke:#1976d2,stroke-width:3px
    style DT fill:#fff3e0,stroke:#ff9800,stroke-width:2px
    style AT fill:#e8f5e9,stroke:#4caf50,stroke-width:2px
    style ML fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
    style OR fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    style TM fill:#e0f2f1,stroke:#009688,stroke-width:2px
    style PG fill:#f1f8e9,stroke:#689f38,stroke-width:2px
```

## Atomic Design System

### 1. Atoms (Basic Building Blocks)

```mermaid
graph LR
    subgraph Atoms
        A1[Button<br/>CTA Actions]
        A2[Icon<br/>Visual Elements]
        A3[Typography<br/>Text Styles]
        A4[Input<br/>User Entry]
        A5[Badge<br/>Status/Count]
        A6[Avatar<br/>User Image]
        A7[Divider<br/>Separation]
        A8[Loader<br/>Progress]
    end

    style A1 fill:#e8f5e9,stroke:#4caf50
    style A2 fill:#e8f5e9,stroke:#4caf50
    style A3 fill:#e8f5e9,stroke:#4caf50
    style A4 fill:#e8f5e9,stroke:#4caf50
    style A5 fill:#e8f5e9,stroke:#4caf50
    style A6 fill:#e8f5e9,stroke:#4caf50
    style A7 fill:#e8f5e9,stroke:#4caf50
    style A8 fill:#e8f5e9,stroke:#4caf50
```

### 2. Molecules (Combinations)

```mermaid
graph TB
    subgraph Molecules
        M1[Search Bar<br/>Icon + Input + Button]
        M2[Product Item<br/>Image + Text + Badge]
        M3[Risk Indicator<br/>Icon + Progress + Text]
        M4[Action Card<br/>Icon + Title + Description]
        M5[Notification Banner<br/>Icon + Text + Action]
        M6[Tab Item<br/>Icon + Label + Badge]
    end
    
    A1[Atoms] --> M1
    A1 --> M2
    A1 --> M3
    A1 --> M4
    A1 --> M5
    A1 --> M6

    style M1 fill:#f3e5f5,stroke:#9c27b0
    style M2 fill:#f3e5f5,stroke:#9c27b0
    style M3 fill:#f3e5f5,stroke:#9c27b0
    style M4 fill:#f3e5f5,stroke:#9c27b0
    style M5 fill:#f3e5f5,stroke:#9c27b0
    style M6 fill:#f3e5f5,stroke:#9c27b0
```

### 3. Organisms (Complex Components)

```mermaid
graph TB
    subgraph Organisms
        O1[Navigation Bar<br/>Logo + Menu + Actions]
        O2[Product Card<br/>Image + Info + Actions]
        O3[Scan Result Panel<br/>Product + Risk + Details]
        O4[Health Dashboard<br/>Score + Charts + Stats]
        O5[Filter Panel<br/>Categories + Options]
        O6[Comment Section<br/>User + Text + Actions]
    end
    
    M1[Molecules] --> O1
    M1 --> O2
    M1 --> O3
    M1 --> O4
    M1 --> O5
    M1 --> O6

    style O1 fill:#fce4ec,stroke:#e91e63
    style O2 fill:#fce4ec,stroke:#e91e63
    style O3 fill:#fce4ec,stroke:#e91e63
    style O4 fill:#fce4ec,stroke:#e91e63
    style O5 fill:#fce4ec,stroke:#e91e63
    style O6 fill:#fce4ec,stroke:#e91e63
```

## Component State Management

```mermaid
stateDiagram-v2
    [*] --> Default
    Default --> Hover: Mouse Enter
    Default --> Focus: Tab/Click
    Default --> Active: Click/Tap
    Default --> Disabled: Prop Change
    Default --> Loading: Async Action
    
    Hover --> Default: Mouse Leave
    Focus --> Default: Blur
    Active --> Default: Release
    Disabled --> Default: Enable
    Loading --> Success: Complete
    Loading --> Error: Fail
    
    Success --> Default: Timeout
    Error --> Default: Retry/Dismiss
```

## Component Communication Flow

```mermaid
graph TB
    subgraph Component Communication
        PS[Parent State] --> PC[Parent Component]
        PC --> C1[Child 1]
        PC --> C2[Child 2]
        PC --> C3[Child 3]
        
        C1 --> E1[Events/Callbacks]
        C2 --> E2[Events/Callbacks]
        C3 --> E3[Events/Callbacks]
        
        E1 --> PS
        E2 --> PS
        E3 --> PS
        
        PS --> GS[Global State]
        GS --> CT[Context/Store]
        CT --> PC
    end

    style PS fill:#e3f2fd,stroke:#1976d2
    style GS fill:#fff3e0,stroke:#ff9800
    style CT fill:#e8f5e9,stroke:#4caf50
```

## Responsive Component Architecture

```mermaid
graph LR
    subgraph Responsive System
        BP[Breakpoints] --> SM[Small<br/>0-374px]
        BP --> MD[Medium<br/>375-413px]
        BP --> LG[Large<br/>414-767px]
        BP --> XL[Tablet<br/>768px+]
        
        SM --> L1[Single Column]
        MD --> L2[Flexible Grid]
        LG --> L3[Enhanced Layout]
        XL --> L4[Multi Column]
    end

    style BP fill:#f3e5f5,stroke:#9c27b0
    style SM fill:#e8f5e9,stroke:#4caf50
    style MD fill:#fff3e0,stroke:#ff9800
    style LG fill:#e3f2fd,stroke:#1976d2
    style XL fill:#fce4ec,stroke:#e91e63
```

## Data Flow Architecture

```mermaid
graph TD
    subgraph Data Flow
        UI[UI Layer] --> AC[Action Creators]
        AC --> API[API Calls]
        API --> BE[Backend Services]
        BE --> DB[(Database)]
        
        BE --> RES[Response]
        RES --> RD[Reducers]
        RD --> ST[Store]
        ST --> UI
        
        ST --> SEL[Selectors]
        SEL --> COMP[Components]
        COMP --> UI
    end

    style UI fill:#e8f5e9,stroke:#4caf50
    style API fill:#e3f2fd,stroke:#1976d2
    style BE fill:#fff3e0,stroke:#ff9800
    style DB fill:#fce4ec,stroke:#e91e63
    style ST fill:#f3e5f5,stroke:#9c27b0
```

## Animation System

```mermaid
graph TB
    subgraph Animation Types
        AT1[Micro-interactions<br/>0-300ms]
        AT2[Transitions<br/>300-600ms]
        AT3[Complex Animations<br/>600-1000ms]
        
        AT1 --> MI1[Button Press]
        AT1 --> MI2[Toggle Switch]
        AT1 --> MI3[Hover Effects]
        
        AT2 --> TR1[Page Transitions]
        AT2 --> TR2[Modal Open/Close]
        AT2 --> TR3[Tab Switches]
        
        AT3 --> CA1[Loading Sequences]
        AT3 --> CA2[Data Visualizations]
        AT3 --> CA3[Onboarding Flows]
    end

    style AT1 fill:#e8f5e9,stroke:#4caf50
    style AT2 fill:#fff3e0,stroke:#ff9800
    style AT3 fill:#fce4ec,stroke:#e91e63
```

## Component Testing Strategy

```mermaid
graph LR
    subgraph Testing Pyramid
        UT[Unit Tests<br/>70%] --> IT[Integration Tests<br/>20%]
        IT --> E2E[E2E Tests<br/>10%]
        
        UT --> UT1[Component Logic]
        UT --> UT2[Utility Functions]
        UT --> UT3[Reducers]
        
        IT --> IT1[Component Integration]
        IT --> IT2[API Integration]
        IT --> IT3[State Management]
        
        E2E --> E1[User Flows]
        E2E --> E2[Critical Paths]
        E2E --> E3[Cross-platform]
    end

    style UT fill:#e8f5e9,stroke:#4caf50
    style IT fill:#fff3e0,stroke:#ff9800
    style E2E fill:#fce4ec,stroke:#e91e63
```

## Performance Optimization Flow

```mermaid
graph TD
    subgraph Performance
        P1[Initial Load] --> O1[Code Splitting]
        O1 --> O2[Lazy Loading]
        O2 --> O3[Bundle Optimization]
        
        P2[Runtime Performance] --> R1[Memoization]
        R1 --> R2[Virtual Lists]
        R2 --> R3[Debouncing]
        
        P3[Asset Optimization] --> A1[Image Compression]
        A1 --> A2[SVG Sprites]
        A2 --> A3[Font Subsetting]
        
        O3 --> PERF[Optimized App]
        R3 --> PERF
        A3 --> PERF
    end

    style P1 fill:#e3f2fd,stroke:#1976d2
    style P2 fill:#e8f5e9,stroke:#4caf50
    style P3 fill:#fff3e0,stroke:#ff9800
    style PERF fill:#fce4ec,stroke:#e91e63
```

## Accessibility Component Tree

```mermaid
graph TB
    subgraph Accessibility
        A11Y[Accessibility Root] --> SR[Screen Reader]
        A11Y --> KB[Keyboard Nav]
        A11Y --> CO[Color Contrast]
        A11Y --> FO[Focus Management]
        
        SR --> SR1[ARIA Labels]
        SR --> SR2[Alt Text]
        SR --> SR3[Announcements]
        
        KB --> KB1[Tab Order]
        KB --> KB2[Skip Links]
        KB --> KB3[Shortcuts]
        
        CO --> CO1[WCAG AAA]
        CO --> CO2[Dark Mode]
        CO --> CO3[High Contrast]
        
        FO --> FO1[Focus Trap]
        FO --> FO2[Focus Visible]
        FO --> FO3[Focus Return]
    end

    style A11Y fill:#f3e5f5,stroke:#9c27b0
    style SR fill:#e8f5e9,stroke:#4caf50
    style KB fill:#e3f2fd,stroke:#1976d2
    style CO fill:#fff3e0,stroke:#ff9800
    style FO fill:#fce4ec,stroke:#e91e63
```

## Theme System Architecture

```mermaid
graph TD
    subgraph Theme System
        TS[Theme Provider] --> LT[Light Theme]
        TS --> DT[Dark Theme]
        TS --> CT[Custom Theme]
        
        LT --> LC[Light Colors]
        LT --> LF[Light Fonts]
        LT --> LS[Light Shadows]
        
        DT --> DC[Dark Colors]
        DT --> DF[Dark Fonts]
        DT --> DS[Dark Shadows]
        
        CT --> UC[User Colors]
        CT --> UF[User Fonts]
        CT --> US[User Settings]
        
        TS --> COMP[Components]
        COMP --> UI[UI Render]
    end

    style TS fill:#e3f2fd,stroke:#1976d2
    style LT fill:#fff,stroke:#757575
    style DT fill:#212121,stroke:#fff
    style CT fill:#f3e5f5,stroke:#9c27b0
```