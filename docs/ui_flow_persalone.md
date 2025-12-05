# UI Flow - PersalOne

## 1. Onboarding (`OnboardingPage`)

**Main Texts:**
-   **Title:** "Bienvenido a PersalOne"
-   **Body:** "Tu coach personal de seguridad digital y agente de IA..."

**Main Actions:**
-   **"Empezar con mi panel" (Primary Button):** Navigates to **Home**.
-   **"Saltar por ahora" (Text Button):** Navigates to **Home**.

**Accessibility/Language:**
-   Texts are hardcoded in Spanish in this file (not using `l10n` yet for this screen).
-   Standard text scaling applies.

---

## 2. Home Page (`HomePage`)

**Main Texts:**
-   **Title:** "My security status" (`homeTitle`)
-   **Beta Badge:** "BETA"
-   **Beta Message:** "Your dashboard is in beta mode..." (`homeBetaMessage`)
-   **Section Title:** "Quick actions" (`homeQuickActions`)
-   **Footer:** "Technical beta version..." (`homeFooterNote`)

**Main Actions:**
-   **"Talk to my AI agent" (Primary Button):** Navigates to **Agent**.
-   **"View plans and pricing" (Secondary Button):** Navigates to **Pricing**.
-   **"Basic security checklist" (Secondary Button):** Shows a "Checklist not yet available" SnackBar.
-   **Settings Icon (AppBar Action):** Navigates to **Settings**.

**Accessibility/Language:**
-   Fully localized using `AppLocalizations`.
-   Semantic labels on buttons.

---

## 3. Pricing Page (`PricingPage`)

**Main Texts:**
-   **Title:** "Plans and Pricing" (`pricingTitle`)
-   **Disclaimer:** "In-app purchases and subscriptions are NOT active..." (`pricingDisclaimer`)
-   **Sections:** "For individuals", "For teams and businesses".

**Main Actions:**
-   **Plan Cards:** Currently informational only (no tap action implemented).
    -   **Individual:** Free, Ally Monthly.
    -   **Business:** Team Start, Team Guard, Team Shield.

**Accessibility/Language:**
-   Fully localized.
-   High contrast warning in disclaimer (yellow/orange background).
-   Price formatting handles locale (comma vs dot).

---

## 4. Agent Page (`AgentPage`)

**Main Texts:**
-   **Title:** "Your Security Ally" (`agentTitle`)
-   **Welcome Message:** "Hello! I'm your digital security ally..." (`agentWelcomeMessage`) - Shown when chat is empty.

**Main Actions:**
-   **Text Input:** Type message.
-   **Send Button:** Sends message to AI agent.
-   **Back Button:** Returns to **Home**.

**Accessibility/Language:**
-   Fully localized.
-   Input field has hint text (`agentInputPlaceholder`).
-   Loading indicator during message sending.
-   Error handling with "Retry" action in SnackBar.

---

## 5. Settings Page (`SettingsPage`)

**Main Texts:**
-   **Title:** "Settings" (`settings`)
-   **Section:** "Accessibility" (`settingsAccessibility`)
-   **Info Card:** "Accessibility settings will be applied in future versions..." (`settingsInfoMessage`)

**Main Actions:**
-   **Large Text (Switch):** Toggles `largeText` setting.
-   **High Contrast (Switch):** Toggles `highContrast` setting.
-   **Easy Reading Mode (Switch):** Toggles `simplifiedLayout` setting.

**Accessibility/Language:**
-   Fully localized.
-   Switches have titles and subtitles for clarity.
-   **Note:** Toggles currently update local state but do not yet affect the global app theme or persist data.
