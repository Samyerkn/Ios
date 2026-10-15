import UIKit

struct Favorite {
    let imageName: String
    let title: String
    let details: String
}

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    private let favorites: [Favorite] = [
        Favorite(imageName: "Мартин Иден", title: "Мартин Иден — Джек Лондон",
                 details: "Молодой моряк мечтает стать писателем и пробиться в мир, который ему чужд."),
        Favorite(imageName: "спеши любить", title: "Спеши любить — Николас Спаркс",
                 details: "История первой любви, которая меняет жизнь подростка и помогает ему повзрослеть."),
        Favorite(imageName: "451° по Фаренгейту", title: "451° по Фаренгейту — Рэй Брэдбери",
                 details: "В мире, где книги сжигают, пожарный начинает сомневаться в установленном порядке."),
        Favorite(imageName: "цветы для элджернена", title: "Цветы для Элджернона — Дэниел Киз",
                 details: "Эксперимент меняет жизнь Чарли и заставляет его по-новому увидеть себя и окружающих."),
        Favorite(imageName: "Лучшее во мне", title: "Лучшее во мне — Николас Спаркс",
                 details: "Спустя годы бывшие возлюбленные встречаются вновь и вспоминают первую любовь."),
        Favorite(imageName: "Дневник памяти", title: "Дневник памяти — Николас Спаркс",
                 details: "История любви, которая пережила время и множество испытаний."),
        Favorite(imageName: "Семь сестёр", title: "Семь сестёр — Люсинда Райли",
                 details: "После смерти приёмного отца сёстры отправляются на поиски своих корней."),
        Favorite(imageName: "Гарри Поттер", title: "Гарри Поттер и философский камень — Дж. К. Роулинг",
                 details: "Первый год в Хогвартсе открывает Гарри мир магии и тайну его прошлого."),
        Favorite(imageName: "Алхимик", title: "Алхимик — Пауло Коэльо",
                 details: "Пастух Сантьяго отправляется на поиски сокровища и своего предназначения."),
        Favorite(imageName: "Таинственный сад", title: "Таинственный сад — Фрэнсис Бёрнетт",
                 details: "Мэри находит заброшенный сад и постепенно открывает его секреты.")
    ]
    private var currentIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        descriptionLabel.numberOfLines = 0
        show(at: nextIndex())
    }

    @IBAction func randomTapped(_ sender: UIButton) {
        show(at: nextIndex())
    }

    /// Random index that differs from the one shown right now.
    private func nextIndex() -> Int {
        var candidates = Array(favorites.indices)
        if let current = currentIndex {
            candidates.removeAll { $0 == current }
        }
        return candidates.randomElement() ?? 0
    }

    private func show(at index: Int) {
        guard favorites.indices.contains(index) else { return }
        currentIndex = index
        let favorite = favorites[index]
        imageView.image = UIImage(named: favorite.imageName)
        titleLabel.text = favorite.title
        descriptionLabel.text = favorite.details
    }
}
