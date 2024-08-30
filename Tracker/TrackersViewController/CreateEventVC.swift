//
//  CreateEventVC.swift
//  Tracker
//
//  Created by Мария Шагина on 10.08.2024.
//

import UIKit

enum Event {
    case regular
    case irregular
    
    var titleText: String {
        switch self {
        case .regular:
            return "Новая привычка"
        case .irregular:
            return "Новое нерегулярное событие"
        }
    }
    
    var editTitleText: String {
        switch self {
        case .regular:
            return "Редактирование привычки"
        case .irregular:
            return "Редактирование привычки"
        }
    }
}



protocol CreateEventVCDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, categoryName: String)
}

final class CreateEventVC: UIViewController {
    
    // MARK: - properties and arrays
    private let colors = Colors()
    public weak var delegate: CreateEventVCDelegate?
    
    private let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍒",
        "🍔", "🥦", "🏓", "🥇", "🎸", "🏝"
    ]
    
    private let colorsArray = [
        UIColor.ypColorSelection1,
        UIColor.ypColorSelection2,
        UIColor.ypColorSelection3,
        UIColor.ypColorSelection4,
        UIColor.ypColorSelection5,
        UIColor.ypColorSelection6,
        UIColor.ypColorSelection7,
        UIColor.ypColorSelection8,
        UIColor.ypColorSelection9,
        UIColor.ypColorSelection10,
        UIColor.ypColorSelection11,
        UIColor.ypColorSelection12,
        UIColor.ypColorSelection13,
        UIColor.ypColorSelection14,
        UIColor.ypColorSelection15,
        UIColor.ypColorSelection16,
        UIColor.ypColorSelection17,
        UIColor.ypColorSelection18,
    ].compactMap { color in
        if let color { return color }
        return nil
    }
    
    
    private let collectionViewHeader = ["Emoji", "Цвет"]
    private let event: Event
    private let nameCell = ["Категория", "Расписание"]
    private let limitNumberOfCharacters = 38
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var numberOfCharacters = 0
    private var heightAnchor: NSLayoutConstraint?
    var editTracker: Tracker?
    var editTrackerDate: Date?
    private var completedTrackers: [TrackerRecord] = []
    private var schedule: [WeekDay] = [] {
        didSet {
            updateCreateEventButton()
        }
    }
    var category: TrackerCategory? = nil {
        didSet {
            updateCreateEventButton()
        }
    }
    private var selectedEmojiCell: IndexPath? = nil
    private var selectedColorCell: IndexPath? = nil
    private var selectedEmoji: String = "" {
        didSet {
            updateCreateEventButton()
        }
    }
    private var selectedColor: UIColor? = nil {
        didSet {
            updateCreateEventButton()
        }
    }
    private var scheduleSubTitle: String = ""
    private var dayOfWeek: [String] = []
    
    var selectedCategory: TrackerCategory?
    var categorySubTitle: String = ""
    
    
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 450)
    }
    
    private lazy var titleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var completedDaysBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var completedDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = "Дней"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypColorSelection2
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypColorSelection2
        button.layer.cornerRadius = 17
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(minusButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = editTracker == nil ? event.titleText : event.editTitleText
        label.font = UIFont.ypMediumSize16
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.indent(size: 10)
        textField.placeholder = "Введите название трекера"
        textField.textColor = .ypBlack
        textField.backgroundColor = .backgroundColor
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        UITextField.appearance().clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypRed
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createEventView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var forwardImage1: UIImageView = {
        let forwardImage = UIImageView()
        forwardImage.image = UIImage(named: "chevronForward")
        forwardImage.translatesAutoresizingMaskIntoConstraints = false
        return forwardImage
    }()
    
    private lazy var forwardImage2: UIImageView = {
        let forwardImage = UIImageView()
        forwardImage.image = UIImage(named: "chevronForward")
        forwardImage.translatesAutoresizingMaskIntoConstraints = false
        return forwardImage
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(categoryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var categoryButtonTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = "Категория"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryButtonSubTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.text = categorySubTitle
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(scheduleButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scheduleButtonTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scheduleButtonSubTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.text = scheduleSubTitle
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiAndColorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiAndColorCollectionViewCell.self, forCellWithReuseIdentifier: EmojiAndColorCollectionViewCell.identifier)
        collectionView.register(EmojiColorHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojiColorHeaderReusableView.identifier)
        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var createEventButton: UIButton = {
        let button = UIButton()
        var titleButton = editTracker == nil ? "Создать" : "Сохранить"
        button.setTitleColor(.ypWhite, for: .normal)
        button.setTitle(titleButton, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createEventButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor.ypRed, for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - init
    init(_ event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBG
        addSubviews()
        setupLayout()
        setupEditTracker()
        emojiAndColorCollectionView.allowsMultipleSelection = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let indexPathEmoji = emojies.firstIndex(where: {$0 == selectedEmoji}) else { return }
        let cellEmoji = self.emojiAndColorCollectionView.cellForItem(at: IndexPath(row: indexPathEmoji, section: 0))
        cellEmoji?.backgroundColor = .ypLightGray
        selectedEmojiCell = IndexPath(row: indexPathEmoji, section: 0)
        
        guard let indexPathColor = colorsArray.firstIndex(where: {$0.hexString == selectedColor?.hexString}) else { return }
        let cellColor = self.emojiAndColorCollectionView.cellForItem(at: IndexPath(row: indexPathColor, section: 1))
        cellColor?.layer.borderWidth = 3
        cellColor?.layer.cornerRadius = 8
        cellColor?.layer.borderColor = selectedColor?.withAlphaComponent(0.3).cgColor
        selectedColorCell = IndexPath(item: indexPathColor, section: 1)
    }
    
    // MARK: - methods
    private func setupEditTracker() {
        if let editTracker = editTracker {
            schedule = editTracker.schedule ?? []
            textField.text = editTracker.name
            selectedEmoji = editTracker.emoji ?? ""
            selectedColor = editTracker.color ?? nil
            createSchedule(schedule: schedule)
            categorySubTitle = category?.title ?? ""
            completedDaysBackgroundView.isHidden = false
            updateScheduleButton()
            updateCategoryButton()
            updatePlusMinusButtons()
        }
    }
    
    private func updatePlusMinusButtons() {
        if let editTracker = editTracker,
           let editTrackerDate = editTrackerDate {
            completedTrackers = trackerRecordStore.trackerRecords
            let completedCount = completedTrackers.filter({ record in
                record.idTracker == editTracker.id
            }).count
            completedDaysLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDay", comment: "дней"), completedCount)
            if completedTrackers.firstIndex(where: { record in
                record.idTracker == editTracker.id &&
                record.date.yearMonthDayComponents == editTrackerDate.yearMonthDayComponents
            }) != nil {
                minusButton.isEnabled = true
                plusButton.isEnabled = false
            } else {
                minusButton.isEnabled = false
                plusButton.isEnabled = true
            }
        }
    }
    
    private func updateCreateEventButton() {
        createEventButton.isEnabled = textField.text?.isEmpty == false && selectedColor != nil && !selectedEmoji.isEmpty && category != nil
        if event == .regular {
            createEventButton.isEnabled = createEventButton.isEnabled && !schedule.isEmpty
        }
        
        if createEventButton.isEnabled {
            createEventButton.backgroundColor = .ypBlack
        } else {
            createEventButton.backgroundColor = .gray
        }
    }
    
    // MARK: -  actions
    @objc private func createEventButtonAction() {
        var tracker: Tracker?
        if editTracker == nil {
            if event == .regular {
                tracker = Tracker(id: UUID(), name: textField.text ?? "", color: selectedColor, emoji: selectedEmoji, schedule: schedule, pinned: false)
            } else {
                schedule = WeekDay.allCases
                tracker = Tracker(id: UUID(), name: textField.text ?? "", color: selectedColor, emoji: selectedEmoji, schedule: schedule, pinned: false)
            }
            guard let tracker = tracker else { return }
            delegate?.createTracker(tracker, categoryName: category?.title ?? "Без категории")
            
        } else {
            guard let editTracker = editTracker else { return }
            
            try? trackerStore.updateTracker(
                newNameTracker: textField.text ?? "",
                newEmoji: selectedEmoji,
                newColor: selectedColor?.hexString ?? "",
                newSchedule: schedule,
                categoryName: category?.title ?? "Без категории",
                editableTracker: editTracker
            )
        }
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonAction() {
        dismiss(animated: true)
    }
    
    @objc private func categoryButtonAction() {
        let categoryVC = CategoryView(delegate: self, selectedCategory: category)
        present(categoryVC, animated: true)
    }
    
    @objc private func scheduleButtonAction() {
        let scheduleVC = ScheduleVC()
        scheduleVC.delegate = self
        scheduleVC.schedule = schedule
        present(scheduleVC, animated: true)
    }
    
    // MARK: - UI methods
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(titleBackgroundView)
        titleBackgroundView.addSubview(label)
        scrollView.addSubview(completedDaysBackgroundView)
        completedDaysBackgroundView.addSubview(plusButton)
        completedDaysBackgroundView.addSubview(minusButton)
        completedDaysBackgroundView.addSubview(completedDaysLabel)
        scrollView.addSubview(textField)
        scrollView.addSubview(errorLabel)
        scrollView.addSubview(createEventView)
        createEventView.addSubview(categoryButton)
        categoryButton.addSubview(forwardImage1)
        if event == .regular {
            createEventView.addSubview(separatorView)
            createEventView.addSubview(scheduleButton)
            scheduleButton.addSubview(forwardImage2)
        }
        updateScheduleButton()
        updateCategoryButton()
        scrollView.addSubview(emojiAndColorCollectionView)
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.addSubview(createEventButton)
        buttonBackgroundView.addSubview(cancelButton)
    }
    
    private func setupLayout() {
        let createEventViewHeight: CGFloat = event == .regular ? 150 : 75
        let textFieldTop: CGFloat = editTracker == nil ? 24 : 102
        heightAnchor = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        var constraints = [
            
            titleBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackgroundView.heightAnchor.constraint(equalToConstant: 52),
            
            label.centerXAnchor.constraint(equalTo: titleBackgroundView.centerXAnchor),
            label.topAnchor.constraint(equalTo: titleBackgroundView.topAnchor, constant: 27),
            label.heightAnchor.constraint(equalToConstant: 25),
            label.widthAnchor.constraint(equalToConstant: 250),
            
            scrollView.topAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonBackgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            completedDaysBackgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            completedDaysBackgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            completedDaysBackgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            completedDaysBackgroundView.heightAnchor.constraint(equalToConstant: 38),
            
            completedDaysLabel.widthAnchor.constraint(equalToConstant: 120),
            completedDaysLabel.centerXAnchor.constraint(equalTo: completedDaysBackgroundView.centerXAnchor),
            completedDaysLabel.heightAnchor.constraint(equalToConstant: 38),
            
            plusButton.trailingAnchor.constraint(equalTo: completedDaysBackgroundView.trailingAnchor, constant: -78),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            
            minusButton.leadingAnchor.constraint(equalTo: completedDaysBackgroundView.leadingAnchor, constant: 78),
            minusButton.widthAnchor.constraint(equalToConstant: 34),
            minusButton.heightAnchor.constraint(equalToConstant: 34),
            minusButton.topAnchor.constraint(equalTo: completedDaysBackgroundView.topAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: textFieldTop),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0),
            errorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            heightAnchor!,
            
            createEventView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            createEventView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            createEventView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            createEventView.heightAnchor.constraint(equalToConstant: createEventViewHeight),
            
            categoryButton.topAnchor.constraint(equalTo: createEventView.topAnchor),
            categoryButton.bottomAnchor.constraint(equalTo:  self.event == .regular ? separatorView.topAnchor : createEventView.bottomAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: createEventView.trailingAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: createEventView.leadingAnchor),
            
            forwardImage1.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -24),
            forwardImage1.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            
            emojiAndColorCollectionView.topAnchor.constraint(equalTo: createEventView.bottomAnchor, constant: 22),
            emojiAndColorCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            emojiAndColorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            emojiAndColorCollectionView.widthAnchor.constraint(equalToConstant: scrollView.bounds.width - 32),
            emojiAndColorCollectionView.heightAnchor.constraint(equalToConstant: 450),
            
            buttonBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonBackgroundView.heightAnchor.constraint(equalToConstant: 80),
            
            cancelButton.leadingAnchor.constraint(equalTo: buttonBackgroundView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: buttonBackgroundView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createEventButton.trailingAnchor.constraint(equalTo: buttonBackgroundView.trailingAnchor, constant: -20),
            createEventButton.bottomAnchor.constraint(equalTo: buttonBackgroundView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createEventButton.widthAnchor.constraint(equalToConstant: 161),
            createEventButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        if event == .regular {
            constraints += [
                separatorView.centerYAnchor.constraint(equalTo: createEventView.centerYAnchor),
                separatorView.trailingAnchor.constraint(equalTo: createEventView.trailingAnchor, constant: -10),
                separatorView.leadingAnchor.constraint(equalTo: createEventView.leadingAnchor, constant: 10),
                separatorView.heightAnchor.constraint(equalToConstant: 0.5),
                
                scheduleButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
                scheduleButton.bottomAnchor.constraint(equalTo: createEventView.bottomAnchor),
                scheduleButton.trailingAnchor.constraint(equalTo: createEventView.trailingAnchor),
                scheduleButton.leadingAnchor.constraint(equalTo: createEventView.leadingAnchor),
                forwardImage2.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -24),
                forwardImage2.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor)
            ]
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func updateScheduleButton() {
        if scheduleSubTitle == "" {
            scheduleButton.addSubview(scheduleButtonTitle)
            NSLayoutConstraint.activate([
                scheduleButtonTitle.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
                scheduleButtonTitle.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16)
            ])
            scheduleButtonSubTitle.isHidden = true
        } else {
            scheduleButtonTitle.removeFromSuperview()
            scheduleButton.addSubview(scheduleButtonTitle)
            scheduleButton.addSubview(scheduleButtonSubTitle)
            NSLayoutConstraint.activate([
                scheduleButtonTitle.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
                scheduleButtonTitle.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 15),
                scheduleButtonSubTitle.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
                scheduleButtonSubTitle.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: -13)
            ])
            scheduleButtonSubTitle.text = scheduleSubTitle
            scheduleButtonSubTitle.isHidden = false
        }
    }
    
    func updateCategoryButton() {
        if categorySubTitle == "" {
            categoryButton.addSubview(categoryButtonTitle)
            NSLayoutConstraint.activate([
                categoryButtonTitle.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
                categoryButtonTitle.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16)
            ])
        } else {
            categoryButtonTitle.removeFromSuperview()
            categoryButton.addSubview(categoryButtonTitle)
            categoryButton.addSubview(categoryButtonSubTitle)
            NSLayoutConstraint.activate([
                categoryButtonTitle.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 15),
                categoryButtonTitle.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
                categoryButtonSubTitle.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
                categoryButtonSubTitle.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: -14)
            ])
            categoryButtonSubTitle.text = categorySubTitle
        }
    }
    
    @objc private func textFieldChanged() {
        updateCreateEventButton()
        guard let number = textField.text?.count else { return }
        numberOfCharacters = number
        if numberOfCharacters < limitNumberOfCharacters {
            errorLabel.text = ""
            heightAnchor?.constant = 0
        } else {
            errorLabel.text = "Ограничение 38 символов"
            heightAnchor?.constant = 32
        }
    }
    
    @objc private func plusButtonAction() {
        if let editTracker = editTracker,
           let editTrackerDate = editTrackerDate {
            let record = TrackerRecord(idTracker: editTracker.id, date: editTrackerDate)
            completedTrackers.append(record)
            try? trackerRecordStore.addNewTrackerRecord(record)
        }
        updatePlusMinusButtons()
    }
    
    @objc private func minusButtonAction() {
        if let editTracker = editTracker,
           let editTrackerDate = editTrackerDate {
            if let index = completedTrackers.firstIndex(where: { record in
                record.idTracker == editTracker.id &&
                record.date.yearMonthDayComponents == editTrackerDate.yearMonthDayComponents
            }) {
                completedTrackers.remove(at: index)
                try? trackerRecordStore.deleteTrackerRecord(with: editTracker.id, date: editTrackerDate)
            }
        }
        updatePlusMinusButtons()
    }
}

// MARK: - UITextFieldDelegate
extension CreateEventVC: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let maxLenght = limitNumberOfCharacters
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLenght
    }
}

// MARK: - ScheduleVCDelegate
extension CreateEventVC: ScheduleVCDelegate {
    func createSchedule(schedule: [WeekDay]) {
        self.schedule = schedule
        let scheduleString = schedule.map { $0.shortName }.joined(separator: ", ")
        scheduleSubTitle = scheduleString == "Пн, Вт, Ср, Чт, Пт, Сб, Вс" ? "Каждый день" : scheduleString
        updateScheduleButton()
    }
}

// MARK: - CategoryListViewModelDelegate
extension CreateEventVC: CategoryListViewModelDelegate {
    func createCategory(category: TrackerCategory) {
        self.category = category
        let categoryString = category.title
        categorySubTitle = categoryString
        updateCategoryButton()
    }
}

// MARK: - UICollectionViewDataSource
extension CreateEventVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue = Int()
        if section == 0 {
            returnValue = emojies.count
        } else if section == 1 {
            returnValue = colorsArray.count
        }
        return returnValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        
        guard let cell = emojiAndColorCollectionView.dequeueReusableCell(withReuseIdentifier: "emojiAndColorCollectionViewCell", for: indexPath) as? EmojiAndColorCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 16
        
        if section == 0 {
            cell.emojiLabel.text = emojies[indexPath.row]
        } else if section == 1 {
            cell.colorView.backgroundColor = colorsArray[indexPath.row]
            cell.colorView.layer.cornerRadius = 8
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
}

// MARK: - UICollectionViewDelegate
extension CreateEventVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCollectionViewCell
        if section == 0 {
            if selectedEmojiCell != nil {
                collectionView.deselectItem(at: selectedEmojiCell!, animated: true)
                collectionView.cellForItem(at: selectedEmojiCell!)?.backgroundColor = .white
            }
            cell?.backgroundColor = .ypLightGray
            selectedEmoji = cell?.emojiLabel.text ?? ""
            selectedEmojiCell = indexPath
        } else if section == 1 {
            if selectedColorCell != nil {
                collectionView.deselectItem(at: selectedColorCell!, animated: true)
                collectionView.cellForItem(at: selectedColorCell!)?.layer.borderWidth = 0
            }
            cell?.layer.borderWidth = 3
            cell?.layer.cornerRadius = 8
            selectedColor = cell?.colorView.backgroundColor ?? nil
            cell?.layer.borderColor = selectedColor?.withAlphaComponent(0.3).cgColor
            selectedColorCell = indexPath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCollectionViewCell
        collectionView.deselectItem(at: indexPath, animated: true)
        cell?.backgroundColor = .white
        cell?.layer.borderWidth = 0
        if indexPath.section == 0 {
            selectedEmoji = ""
            selectedEmojiCell = nil
        } else {
            selectedColor = nil
            selectedColorCell = nil
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreateEventVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        guard let view = emojiAndColorCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? EmojiColorHeaderReusableView else { return UICollectionReusableView() }
        let section = indexPath.section
        if section == 0 {
            view.titleLabel.text = collectionViewHeader[0]
        } else if section == 1 {
            view.titleLabel.text = collectionViewHeader[1]
        }
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - TrackerRecordStoreDelegate
extension CreateEventVC: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        completedTrackers = trackerRecordStore.trackerRecords
    }
}
