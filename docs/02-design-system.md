# 02. Design System - Neumorphism 3D

## Color Tokens
- **Base Surface Background**: `#F0F4F8` (Soft Gray-Blue)
- **Primary Accent**: `#1E40AF` (Lirboyo Deep Blue)
- **Secondary Accent**: `#93C5FD` (Soft Sky Blue)
- **Success Badge**: `#86EFAC` (Emerald Green)
- **Warning Badge**: `#FDBA74` (Warm Amber)
- **Danger Badge**: `#FCA5A5` (Rose Red)

## Neumorphic Shadow System
Prinsip 3D Neumorphism menggunakan dua arah pencahayaan:
1. **Light Highlight** (Top-Left): `rgba(255, 255, 255, 0.9)`
2. **Dark Shadow** (Bottom-Right): `rgba(163, 177, 198, 0.4)`

```css
/* Custom Utility Classes */
.neumorph {
  background-color: #F0F4F8;
  box-shadow: 6px 6px 12px rgba(163, 177, 198, 0.4), -6px -6px 12px rgba(255, 255, 255, 0.9);
}

.neumorph-pressed {
  background-color: #F0F4F8;
  box-shadow: inset 4px 4px 8px rgba(163, 177, 198, 0.4), inset -4px -4px 8px rgba(255, 255, 255, 0.9);
}

.neumorph-floating {
  background-color: #F0F4F8;
  box-shadow: 10px 10px 20px rgba(163, 177, 198, 0.3), -10px -10px 20px rgba(255, 255, 255, 0.9);
}
```

## Typography
- **Font Sans**: `'Inter'`, `'Poppins'`, sans-serif.
- **Header Weights**: `font-extrabold` (800) & `font-bold` (700).
- **Body Weights**: `font-medium` (500) & `font-normal` (400).
