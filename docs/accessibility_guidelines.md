# PersalOne Accessibility Guidelines

## Overview

These guidelines ensure PersalOne is accessible to all users, including those with visual impairments, motor difficulties, cognitive differences, and other accessibility needs.

---

## Text and Typography

### Readable Font Sizes
- **Base font size**: Use comfortable base sizes (equivalent to ~16px on web)
- **Text scaling**: Support `textScaleFactor` up to at least 1.4x without breaking layouts
- **Line length**: Keep lines to a reasonable width for comfortable reading
- **Line height**: Use adequate spacing between lines (1.4-1.6x font size)

### Content Structure
- **Short paragraphs**: Avoid dense blocks of text
- **Clear headings**: Use semantic heading hierarchy
- **Lists**: Use bullet points and numbered lists for scannability
- **Whitespace**: Provide breathing room between sections

---

## Colors and Contrast

### Color Palette
- **Main background**: White (#FFFFFF)
- **Primary color**: Dark Green (#22572B)
- **Secondary color**: Gold (#C69C34)

### Contrast Requirements
- **Body text**: Ensure minimum 4.5:1 contrast ratio
- **Large text** (18pt+): Minimum 3:1 contrast ratio
- **Critical elements**: Avoid light green on white for body text
- **Links and buttons**: Clear visual distinction from surrounding text

### Color Independence
- **Do not rely solely on color** to convey information
- Use icons, labels, or text alongside color coding
- Provide alternative indicators for status and states

---

## Controls and Interaction

### Touch Targets
- **Minimum size**: 44x44 density-independent pixels (dp)
- **Spacing**: Adequate space between interactive elements
- **Visual feedback**: Clear hover, focus, and active states

### Button Design
- **Clear labels**: All buttons must have descriptive text labels
- **Icon-only buttons**: Include accessible labels for screen readers
- **Disabled states**: Must be recognizable without relying only on color (use opacity, patterns, or text)

### Form Controls
- **Labels**: Always provide visible labels for inputs
- **Error messages**: Display clear, specific error text
- **Required fields**: Clearly indicate required vs. optional fields

---

## Navigation and Layout

### Scroll Behavior
- **Scrollable content**: All screens must scroll if content grows (especially with large text enabled)
- **No fixed heights**: Avoid fixed-height containers that may clip text
- **Responsive design**: Adapt to different screen sizes and orientations

### Focus Management
- **Logical order**: Focus moves in a predictable, logical sequence  
- **Visible focus**: Clear visual indicator for keyboard/switch navigation
- **Skip links**: Allow users to skip repetitive navigation where applicable

### Screen Reader Support
- **Semantic elements**: Use appropriate Flutter widgets (Semantics)
- **Descriptive labels**: Provide context for images, icons, and custom controls
- **Announcements**: Important state changes should be announced

---

## Content and Language

### Clear Communication
- **Plain language**: Use calm, simple language
- **Avoid jargon**: Explain technical terms when necessary
- **Active voice**: Prefer direct, active sentences
- **Concise**: Get to the point quickly

### Summarization
- **Complex content**: Offer simplified summary options
- **Long lists**: Provide overview before detailed information
- **Chunking**: Break complex processes into manageable steps

---

## Animations and Motion

### Motion Sensitivity
- **Avoid flashing**: Never use rapidly flashing content (can trigger seizures)
- **Gentle animations**: Keep transitions smooth and subtle
- **Reduce motion**: Respect OS-level "reduce motion" preferences (future implementation)
- **Essential motion only**: Use animation purposefully, not decoratively

### Animation Guidelines
- **Duration**: Keep animations brief (200-400ms)
- **Easing**: Use natural easing curves  
- **Pausable**: Allow users to pause auto-playing content
- **Optional**: Consider providing a setting to disable non-essential animations

---

## Platform-Specific Considerations

### iOS
- **VoiceOver**: Test with VoiceOver enabled
- **Dynamic Type**: Support iOS Dynamic Type
- **Reduce Motion**: Respect system accessibility settings

### Android
- **TalkBack**: Test with TalkBack enabled
- **Font Size**: Support Android system font scaling
- **Accessibility Scanner**: Use Android Accessibility Scanner for testing

---

## Testing Checklist

Before each release, verify:

- [ ] All interactive elements are at least 44x44dp
- [ ] Text scales up to 1.4x without clipping or overlapping
- [ ] All buttons have clear labels (no icon-only critical actions)
- [ ] Color contrast meets WCAG AA standards
- [ ] Screen reader users can navigate and understand all content
- [ ] Keyboard/switch users can access all functionality
- [ ] No flashing or rapidly moving content
- [ ] Long forms and lists are scrollable
- [ ] Error messages are clear and actionable

---

## Resources

- **WCAG 2.1 Guidelines**: https://www.w3.org/WAI/WCAG21/quickref/
- **Material Design Accessibility**: https://m3.material.io/foundations/accessible-design
- **Flutter Accessibility**: https://docs.flutter.dev/accessibility-and-localization/accessibility

---

## Future Enhancements

Planned accessibility improvements:

- [ ] Respect OS "reduce motion" preference
- [ ] High contrast theme
- [ ] Simplified reading mode with reduced visual complexity
- [ ] Keyboard shortcuts for common actions
- [ ] Voice input support
