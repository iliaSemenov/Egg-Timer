//
// Egg Timer App
// Created by Semenov Ilia
// Copyright © 2017 Semenov Ilia. All rights reserved.
//

import UIKit

class AppController: UIViewController, EggPagerDelegate
{
    @IBOutlet weak var timeMinutesOutlet: UILabel!
    @IBOutlet weak var timeSecondsOutlet: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var cooledSwitch: UISwitch!
    @IBOutlet weak var coolIcon: UIImageView!
    @IBOutlet weak var eggSizeIcon: UIImageView!
    @IBOutlet weak var eggSlider: UIView!
    @IBOutlet var readyView: UIVisualEffectView!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var eggView: UIView!
    @IBOutlet var tapToCloseReadyView: UITapGestureRecognizer!
    
    var currentTime = Int()
    
    var timeForCook: [Int] = [610, 190, 250 ] // timeForCook По - умолчанию
    
    var timeForCook_S = [250, 20, 40] // Перепелиные
    var timeForCook_M = [610,  190, 250] // Куриные
    var timeForCook_L = [790, 370, 410] // Утиные
    var timeForCook_XL = [4210, 1210, 2710] // Страусиные
    
    // Тайминги для охлаждённых яиц 
    
    var timeForCook_S_cooled = [270, 30, 55] // Перепелиные
    var timeForCook_M_cooled = [630,  200, 265] // Куриные
    var timeForCook_L_cooled = [810, 380, 425] // Утиные
    var timeForCook_XL_cooled = [4310, 1270, 2750] // Страусиные
    
    
    var names = [NSLocalizedString("HARD-BOILED", comment: "HARD-BOILED"), NSLocalizedString("SOFT-BOILED", comment: "SOFT-BOILED"), NSLocalizedString("POACHED", comment: "POACHED")]
    let eggIcons = ["s_size","m_size","l_size","xl_size"]
    var timer = Timer()
    var timerIsRun = false
    
    let userDefaults = UserDefaults.standard
    let one = EggStateOne()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        switchStatus()
        timeShow()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool
    {
        return true
    }

    @IBAction func startTimer(_ sender: Any)
    {
       if timerIsRun
       {
            timerIsRun = false
            timer.invalidate()
            timeShow()
            stopAnimation()
       }
       else
       {
            timerIsRun = true
            timerRun()
        
            startAnimation()
       }
       buttonSettings()
    }
    
    func numberOfpage(number: Int) // Функция делегата EggPagerDelegate
    {
        pageControl.currentPage = number
        currentTime = timeForCook[number]
        nameOutlet.text = names[number]
        timeShow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) // Значение страницы в EggPager передаётся здесь
    {
        if segue.identifier == "pagerSegue"
        {
            let destinationViewController = segue.destination as? EggPager
            destinationViewController?.pageDelegate = self
        }
    }
    
    func timerRun()
    {
        if timerIsRun && currentTime > 0
        {
          timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AppController.timeShow), userInfo: nil, repeats: timerIsRun)
        }
    }
    
    func timeShow()
    {
        if timerIsRun && currentTime > 0
        {
            currentTime -= 1
            
            if currentTime == 0
            {
                showReadyView()
            }
        }
        else
        {
            currentTime = timeForCook[pageControl.currentPage]

            timerIsRun = false
            timer.invalidate()
        }
        
        timeMinutesOutlet.text = String(format: "%0.2d", currentTime/60)
        timeSecondsOutlet.text = String(format: "%0.2d", currentTime%60)

        buttonSettings()
    }
    
    func buttonSettings()
    {
        if timerIsRun && currentTime > 0
        {
            buttonOutlet.backgroundColor = UIColor.black
            buttonOutlet.setTitle(NSLocalizedString("STOP COOKING", comment: "STOP COOKING"), for: .normal)
            
            eggSlider.isUserInteractionEnabled = false
            cooledSwitch.isUserInteractionEnabled = false
            settingsButtonOutlet.isUserInteractionEnabled = false
            
            cooledSwitch.alpha = 0.5
            settingsButtonOutlet.alpha = 0.5
        }
        else
        {
            let redColor = UIColor(red: 227.0 / 255.0, green: 0.0 / 255.0, blue: 28.0 / 255.0, alpha: 1)
            buttonOutlet.backgroundColor = redColor
            buttonOutlet.setTitle(NSLocalizedString("START COOKING", comment: "START COOKING"), for: .normal)
            
            eggSlider.isUserInteractionEnabled = true
            cooledSwitch.isUserInteractionEnabled = true
            settingsButtonOutlet.isUserInteractionEnabled = true
            
            cooledSwitch.alpha = 1
            settingsButtonOutlet.alpha = 1
        }
    }
    
    @IBAction func cooled(_ sender: Any)
    {
        viewWillAppear(true)
    }
    
    @IBAction func backToAppController(_ segue: UIStoryboardSegue)
    {
        
    }
    
    func showReadyView()
    {
        stopAnimation()
        
        readyView.frame.size = self.view.frame.size
        readyView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        self.view.addSubview(readyView)
        
        UIView.animate(withDuration: 0.2)
        {
            self.readyView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        readyView.addGestureRecognizer(tapToCloseReadyView)
    }
    
    @IBAction func closeReadyForm(_ sender: Any)
    {
        self.readyView.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.5)
        {
            self.readyView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        }
    }
    
    func startAnimation()
    {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 1
        scaleAnimation.repeatCount = Float(timeForCook[pageControl.currentPage])
        scaleAnimation.autoreverses = true
        
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.1
        
        eggView.layer.add(scaleAnimation, forKey: "transform.scale")
    }
    
    func stopAnimation()
    {
        eggView.layer.removeAnimation(forKey: "position")
        eggView.layer.removeAnimation(forKey: "transform.scale")
    }
    
    func switchStatus()
    {
        
        
        if userDefaults.value(forKey: "userEggChoose") != nil
        {
            let eggChoosen =  userDefaults.value(forKey: "userEggChoose") as! Int
            
            let eggIcon  = UIImage(named: eggIcons[userDefaults.value(forKey: "userEggChoose") as! Int])
            eggSizeIcon.image = eggIcon
            
            if cooledSwitch.isOn
            {
                coolIcon.alpha = 1.0
                
                switch eggChoosen
                {
                case 0: timeForCook = timeForCook_S_cooled
                case 1: timeForCook = timeForCook_M_cooled
                case 2: timeForCook = timeForCook_L_cooled
                case 3: timeForCook = timeForCook_XL_cooled
                default: print("Egg choosen error!")
                }
            }
            else
            {
                coolIcon.alpha = 0.2
                
                switch eggChoosen
                {
                case 0: timeForCook = timeForCook_S
                case 1: timeForCook = timeForCook_M
                case 2: timeForCook = timeForCook_L
                case 3: timeForCook = timeForCook_XL
                default: print("Egg choosen error!")
                }
            }
        }
        else
        {
            userDefaults.set(1, forKey: "userEggChoose")
            switchStatus()
        }
    }   
}

