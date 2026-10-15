# Как собрать проект (Xcode, ~10 минут)

1. Xcode → File → New → Project → iOS → **App**. Product Name: `BookRoulette`, Interface: **Storyboard**, Language: **Swift**.
2. Замени в проекте файлы:
   - `ViewController.swift` → из этого архива
   - `Main.storyboard` → из этого архива
   - `Assets.xcassets` → удали старый и перетащи этот (галочка "Copy items", Add to target)
3. Добавь `LaunchScreen.storyboard`: перетащи файл в проект (Copy items, Add to target).
   Затем Target → Info → `Launch Screen` / в Info.plist ключ `UILaunchStoryboardName` = `LaunchScreen`
   (если в проекте уже есть свой LaunchScreen — просто замени его).
4. Target → General → **Display Name** = `Book Roulette`.
   Target → General → App Icons → App Icon = `AppIcon`.
5. Проверь отсутствие Auto Layout: выбери Main.storyboard → File Inspector (правая панель) →
   галочка **Use Auto Layout** должна быть снята (то же для LaunchScreen.storyboard).
   В Document Outline не должно быть папок "Constraints".
6. Если выходит предупреждение про `customModuleProvider="target"` — игнорируй, это норма.
   Запусти (⌘R) на iPhone 15/16 Simulator.
7. Скриншоты (⌘S в Simulator): launch screen (запусти и быстро сделай, либо Debug → Slow Animations),
   main screen, Home Screen с иконкой (Shift+⌘H). Положи в `screenshots/` как launch.png, main.png, home.png.
8. Git: `git init && git add . && git commit -m "Lab 6" && git remote add origin <URL> && git push -u origin main`
   Отправь ссылку на репозиторий.
