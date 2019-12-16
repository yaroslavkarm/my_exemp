

import UIKit

class PresendDayVC: UIViewController, UIScrollViewDelegate {
    private var imageUrl: String = "https://www.metaweather.com/static/img/weather/png/64/%@.png"
    @IBOutlet weak var cityNameL: UILabel?
    @IBOutlet weak var bgView: UIImageView?
    @IBOutlet weak var minTempLabel: UILabel?
    @IBOutlet weak var windSpeedLabel: UILabel?
    @IBOutlet weak var windDirLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var airPreassureLabel: UILabel?
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var dateLabel: UILabel?
    var currentWeather: WeatherElement? { didSet { DispatchQueue.main.async { [weak self] in self?.updateView() } } }
    var cityName: String? { didSet {  DispatchQueue.main.async { [weak self] in self?.updateCityName() } } }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignbackground()
    }
    func assignbackground(){
        let randNumber = Int.random(in: 1...7)
        bgView?.image = UIImage(named: "background\(randNumber)")
    }
    private func updateCityName() {
        self.cityNameL?.text = "Город: \(cityName ?? "")"
    }
    private func updateView(){
        guard let weather = currentWeather else { return }
        dateLabel?.text = weather.applicableDate
        let minTemp = String(format:"%.1f ºC", weather.minTemp ?? "")
        let maxTemp = String(format:"%.1f ºC", weather.maxTemp ?? "")
        minTempLabel?.text = "Градусов: \(minTemp) - \(maxTemp)"
        windSpeedLabel?.text = String(format:"%.0f km/h", weather.windSpeed ?? "")
        windDirLabel?.text = weather.windDirectionCompass
        humidityLabel?.text = "\(currentWeather?.humidity ?? 0)" + "%"
        airPreassureLabel?.text = String(format:"%.0f", weather.airPressure ?? "" ) + "mbar"
        loadIcon(weather.weatherStateAbbr ?? "")
    }
    func loadIcon(_ weatherName: String ) {
        guard let currentUrl = URL(string: String(format: imageUrl, weatherName)) else { return }
        let request: URLRequest = URLRequest(url: currentUrl)
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            guard err == nil, let uData = d else { return }
            DispatchQueue.main.async {
                self.weatherIcon?.image = UIImage(data: uData)
            }
        }.resume();
    }
}
