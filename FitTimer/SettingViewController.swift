import UserNotifications
import UIKit
import AVFoundation

class SettingViewController: UIViewController {
    
   
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var previousButton = UIButton()
    private lazy var nextButton = UIButton()
    private lazy var todayButton = UIButton()
    private lazy var weekStackView = UIStackView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    private var days = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configure()
      
    }
    
    private func configure(){
        self.configureScrollView()
        self.configureContentView()
        self.configureTitleLabel()
        
        self.configurePreviousButton()
        self.configureNextButton()
        self.configureTodayButton()
        
        self.configureWeekStackView()
        self.configureWeekLabel()
        
        self.configureCollectionView()
        
        self.configureCalendar()
        //self.startDayOfTheWeek()
        //self.endDate()
        self.updateTitle()
        self.updateDays()
        self.updateCalendar()
        self.minusMonth()
        self.plusMonth()
        
    }
    
    private func configureScrollView(){
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureContentView(){
        self.scrollView.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func configureTitleLabel(){
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.text = "2000년 01월"
        self.titleLabel.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
    }
    
    private func configurePreviousButton(){
        self.contentView.addSubview(self.previousButton)
        self.previousButton.tintColor = .label
        self.previousButton.setImage(UIImage(systemName: "chevron.left"), for:.normal)
        self.previousButton.addTarget(self, action: #selector(self.didPreviousButtonTouched), for: .touchUpInside)
        self.previousButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.previousButton.widthAnchor.constraint(equalToConstant: 44),
            self.previousButton.heightAnchor.constraint(equalToConstant: 44),
            self.previousButton.trailingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor, constant: -5),
            self.previousButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
 
    private func configureNextButton(){
        self.contentView.addSubview(self.nextButton)
        self.nextButton.tintColor = .label
        self.nextButton.setImage(UIImage(systemName: "chevron.right"), for:.normal)
        self.nextButton.addTarget(self, action: #selector(self.didNextButtonTouched), for: .touchUpInside)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nextButton.widthAnchor.constraint(equalToConstant: 44),
            self.nextButton.heightAnchor.constraint(equalToConstant: 44),
            self.nextButton.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
            self.nextButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
    
    private func configureTodayButton(){
        self.contentView.addSubview(self.todayButton)
        self.todayButton.setTitle("Today", for: .normal)
        self.todayButton.setTitleColor(.systemBackground, for: .normal)
        self.todayButton.backgroundColor = .label
        self.todayButton.layer.cornerRadius = 5
        self.todayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.todayButton.widthAnchor.constraint(equalToConstant: 60),
            self.todayButton.heightAnchor.constraint(equalToConstant: 30),
            self.todayButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.todayButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
    
    private func configureWeekStackView(){
        self.contentView.addSubview(self.weekStackView)
        self.weekStackView.distribution = .fillEqually
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5)
        ])
    }
    private func configureWeekLabel(){
        let dayOfTheWeek = ["일","월","화","수","목","금","토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            self.weekStackView.addArrangedSubview(label)
            
            if i == 0 {
                label.textColor = .systemRed
            } else if i == 6 {
                label.textColor = .systemBlue
            }
        }
    }
    
    private func configureCollectionView(){
        self.contentView.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 10),
            self.collectionView.leadingAnchor.constraint(equalTo: self.weekStackView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.weekStackView.trailingAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.collectionView.widthAnchor, multiplier: 1.5),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    // 현재 날짜에 년,월만 뽑아낸다.
    private func configureCalendar(){
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.today()
    }
    // 현재 날짜에 년,월만 뽑아낸다.
    private func today() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from:components) ?? Date()
        self.updateCalendar()
        self.todayButton.addTarget(self, action: #selector(self.didTodayButtonTouched), for: .touchUpInside)
    }
    
    // 1일이 시작하는 요일을 계산하면 1은 일요일, 7은 토요일로 반환된다.
    // days 배열의 0번 인덱스를 일요일로 표시해주기 위하여 -1을 해준 후 반환한다.
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    // calendarDate가 해당하는 달의 날짜가 며칠까지 있는지 계산하여 반환한다.
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle() {
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.titleLabel.text = date
    }
    
    private func updateDays() {
        self.days.removeAll()
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        for day in Int()..<totalDays {
            if day<startDayOfTheWeek {
                self.days.append("")
                continue
            }
            self.days.append("\(day - startDayOfTheWeek + 1 )")
        }
        
        self.collectionView.reloadData()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    private func minusMonth() {
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month:-1), to: self.calendarDate) ?? Date()
        self.updateCalendar()
    }
    
    private func plusMonth() {
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate) ?? Date()
        self.updateCalendar()
    }
    
    
    // 버튼 기능 구현
    @objc private func didPreviousButtonTouched (_sender: UIButton){
        self.minusMonth()
    }
    
    @objc private func didNextButtonTouched (_sender: UIButton){
        self.plusMonth()
    }
    
    @objc private func didTodayButtonTouched (_sender: UIButton){
        self.today()
    }
}

extension SettingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        cell.update(day: self.days[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.weekStackView.frame.width / 7
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return .zero
    }
    
}
