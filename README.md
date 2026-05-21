# FlutterCafé

> Лабораторная работа №3 по предмету «Разработка мобильных приложений»  
> Фирсов Артем, ИС-302

Приложение-меню кафе на Flutter с поиском по блюдам, корзиной и переключением тёмной/светлой темы.  
Реализован **3-й (продвинутый) уровень** задания: добавлена категория «Основные блюда», корзина с подсчётом суммы и поиск по всему меню.

---

## Скачать APK

[![Download APK](https://img.shields.io/badge/Download-APK-50C8FF?style=for-the-badge&logo=android)](https://github.com/xx-arteeem-xx/flutter-lab-3/releases/latest/download/app-release.apk)

---

## Функциональность

| Уровень | Задание | Статус |
|---------|---------|--------|
| 1 — Базовое | Категория «Основные блюда» (5 блюд с ингредиентами) | ✅ |
| 2 — Среднее | Глобальная корзина + CartScreen + бейдж на иконке | ✅ |
| 3 — Продвинутое | Поиск по всем блюдам через TextField | ✅ |

---

## Стек технологий

| Компонент | Решение |
|-----------|---------|
| Язык | Dart 3.3+ |
| Фреймворк | Flutter 3.24 |
| Дизайн | EAM Design System (glassmorphism) |
| Шрифт | Nunito (Google Fonts) |
| Тема | `ValueNotifier<ThemeMode>` + SharedPreferences |
| Корзина | `ValueNotifier<List<CartItem>>` (in-memory) |
| CI/CD | GitHub Actions → подписанный APK → GitHub Releases |

---

## Сборка

**Требования:** Flutter ≥ 3.24, Android SDK, Java 17

```bash
flutter pub get
flutter run                   # запуск на устройстве/эмуляторе
flutter build apk --release   # debug-подпись
```

---

## CI/CD — подписанный APK

GitHub Actions автоматически собирает и публикует APK при каждом пуше в `main`.

### Настройка секретов

| Секрет | Описание |
|--------|----------|
| `KEYSTORE_BASE64` | Keystore, закодированный в Base64: `base64 -i keystore.jks` |
| `KEY_STORE_PASSWORD` | Пароль хранилища ключей |
| `KEY_PASSWORD` | Пароль ключа |
| `KEY_ALIAS` | Псевдоним ключа (по умолчанию `upload`) |

---

## Структура проекта

```
lib/
├── main.dart                      # async main → SharedPreferences → runApp
├── app.dart                       # App + _MainScaffold (2 таба)
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        # EAM цветовая палитра
│   │   └── app_strings.dart       # Строки интерфейса
│   ├── theme/
│   │   ├── app_theme.dart         # ThemeData light/dark
│   │   └── theme_notifier.dart    # ValueNotifier<ThemeMode>
│   └── cart/
│       └── cart_notifier.dart     # ValueNotifier<List<CartItem>>
├── models/
│   ├── category.dart
│   ├── dish.dart
│   └── cart_item.dart
├── data/
│   └── menu_data.dart             # 5 категорий, 26 блюд
├── widgets/
│   ├── glass_card.dart            # Glassmorphism-карточка
│   └── theme_toggle_button.dart   # Переключатель темы
└── features/
    ├── menu/
    │   ├── categories_screen.dart # Поиск + сетка категорий
    │   ├── dishes_screen.dart     # Список блюд категории
    │   └── dish_detail_screen.dart# Детали + количество + корзина
    ├── cart/
    │   └── cart_screen.dart       # Корзина + итог + оформление
    └── about/
        └── about_screen.dart      # О приложении
```

---

## Лицензия

[Unlicense](LICENSE)
