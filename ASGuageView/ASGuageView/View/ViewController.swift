import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var asGuageView: ASGuageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let score = 600
        scoreLbl.font = UIFont.boldSystemFont(ofSize: 30)
        asGuageView.score = score
        //To draw
        asGuageView.colorArray = getColorArray()
        asGuageView.drawGraph = true
        asGuageView.drawKnob = true
        asGuageView.gapInGraphScore = 20
        
        //Animation
        asGuageView.animate = true
        asGuageView.duration = 2
        
        animateCounter(fromValue: 300, to: score, duration: 2)
    }
    
    func animateCounter(fromValue: Int, to toValue: Int, duration: TimeInterval) {
        var counterValue = fromValue
            let animationStep: Int = toValue > fromValue ? 1 : -1
            let animationInterval = duration / TimeInterval(abs(toValue - fromValue))
            
            self.scoreLbl.text = "\(fromValue)"
            
            Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true) { timer in
                counterValue += animationStep
                self.scoreLbl.text = "\(counterValue)"
                
                if (animationStep > 0 && counterValue >= toValue) || (animationStep < 0 && counterValue <= toValue) {
                    timer.invalidate()
                }
            }
    }

    private func getColorArray() -> [ColorArrayModel] {
        var arr = [ColorArrayModel]()
        
        arr.append(ColorArrayModel(color: .red, startAngle: 300, endAngle: 550))
        arr.append(ColorArrayModel(color:.orange, startAngle: 550, endAngle: 650))
        arr.append(ColorArrayModel(color: .yellow, startAngle: 650, endAngle: 700))
        arr.append(ColorArrayModel(color: .green, startAngle: 700, endAngle: 750))
        arr.append(ColorArrayModel(color: .cyan, startAngle: 750, endAngle: 900))
        return arr
    }
}

