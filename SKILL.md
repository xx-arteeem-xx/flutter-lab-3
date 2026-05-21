# SKILL.md — Контекст для ИИ-ассистентов

Краткая справка по проекту для эффективной работы с кодом в следующих сессиях.

---

## Что это за проект

Flutter-приложение «FlutterCafé» — меню кафе, лабораторная работа №3 (уровень 3).  
Репозиторий: `https://github.com/xx-arteeem-xx/flutter-lab-3`

---

## Архитектура

- **Тема**: `ThemeNotifier extends ValueNotifier<ThemeMode>` + `SharedPreferences` (персистентность)
- **Корзина**: `CartNotifier extends ValueNotifier<List<CartItem>>` (in-memory, сбрасывается при перезапуске)
- **Навигация**: `BottomNavigationBar` + `IndexedStack` (2 таба) + `Navigator.push` внутри таба
- **Состояние**: `setState` + `ValueListenableBuilder` — без Riverpod/Bloc/Provider
- **Создаются в `App`**: `ThemeNotifier(prefs)` и `CartNotifier()`, передаются через конструкторы вниз

## Структура lib/

```
main.dart → app.dart (_MainScaffold: 2 таба)
core/constants/app_colors.dart   — EAM палитра (копия flatter-lab-2)
core/constants/app_strings.dart  — строки UI
core/theme/app_theme.dart        — ThemeData light/dark (копия flatter-lab-2)
core/theme/theme_notifier.dart   — ValueNotifier<ThemeMode>
core/cart/cart_notifier.dart     — ValueNotifier<List<CartItem>>
models/dish.dart, category.dart, cart_item.dart
data/menu_data.dart              — kCategories (5 категорий, 26 блюд)
widgets/glass_card.dart          — glassmorphism (копия flatter-lab-2)
widgets/theme_toggle_button.dart — иконка-переключатель темы
features/menu/categories_screen.dart   — поиск + SliverGrid категорий
features/menu/dishes_screen.dart       — ListView блюд
features/menu/dish_detail_screen.dart  — детали + количество + «В корзину»
features/cart/cart_screen.dart         — корзина + Dismissible + итог
features/about/about_screen.dart       — о приложении (копия flatter-lab-2)
```

---

## Дизайн-система (EAM)

| Токен | Dark | Light |
|-------|------|-------|
| Фон | `#080A11` | `#F4F7FF` |
| Поверхность | `#0E121F` | `#FFFFFF` |
| Акцент | `#50C8FF` | `#173EAC` |
| Текст | `#EFF3FF` | `#4F607F` |
| Nav Bar | `#0D1020` | — |

Шрифт: **Nunito** (`google_fonts`). GlassCard = `BackdropFilter blur(12)` + `Color(0x120E121F)` border в dark; белая карточка с тенью в light.

---

## Меню (kCategories)

5 категорий, 26 блюд. ID блюд: 1xx (завтраки), 2xx (супы), 3xx (напитки), 4xx (десерты), 5xx (основные).  
Градиенты: завтраки amber/orange, супы deepOrange/red, напитки teal/cyan, десерты pink/purple, основные green/teal.

---

## CI/CD

`.github/workflows/release.yml` — 13 шагов, собирает подписанный APK → GitHub Release.  
Секреты: `KEYSTORE_BASE64`, `KEY_STORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`.  
`flutter analyze --no-fatal-infos` — `withOpacity` deprecation warnings не блокируют сборку.

---

## Известные детали

- `withOpacity()` помечен deprecated в Flutter 3.29+, заменяется на `.withValues(alpha:)`. В проекте используется везде — менять только если нужно убрать все предупреждения.
- `android/app/build.gradle` — Groovy (не KTS). CI удаляет `build.gradle.kts` после `flutter create`.
- Иконка приложения: `assets/images/icon.png` (скопирована из flatter-lab-2, нужно заменить на уникальную).
- `flutter_launcher_icons` настроен в `pubspec.yaml`, запускать: `flutter pub run flutter_launcher_icons`.
