//
// Egg Timer App
// Created by Semenov Ilia
// Copyright © 2017 Semenov Ilia. All rights reserved.
//

import UIKit

class Settings: UITableViewController
{
    let eggNames = [NSLocalizedString("Quail", comment: "Quail"), NSLocalizedString("Chicken", comment: "Chicken"), NSLocalizedString("Duck", comment: "Duck"), NSLocalizedString("Ostrich", comment: "Ostrich")]
    let eggIcons = ["s_size_set","m_size_set","l_size_set","xl_size_set"]
    let notificationSoundsNames = [NSLocalizedString("Ding!", comment: "Ding!"),NSLocalizedString("Good morning", comment: "Good morning"),NSLocalizedString("Happy", comment: "Happy"),NSLocalizedString("Success", comment: "Success"),NSLocalizedString("Chiken", comment: "Chiken")]
    
    var userEggChoose = 1
    var userSoundChoose = 0
    
    let userDefaults = UserDefaults.standard
    let lightGrayColor = UIColor(red: 239.0 / 255.0, green:  239.0 / 255.0, blue:  244.0 / 255.0, alpha: 1)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var numberOfRowsInSection = Int()
        
        if section == 0
        {
            numberOfRowsInSection = 4
        }
        else
        {
            numberOfRowsInSection = 5
        }

        return numberOfRowsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        loadFromUserDefaults()
        
        let selectView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        selectView.backgroundColor = lightGrayColor.withAlphaComponent(0.5)
        
        if indexPath.section == 0
        {
            let eggTypeCell = tableView.dequeueReusableCell(withIdentifier: "eggTypeCell") as! EggTypeCell
            eggTypeCell.selectedBackgroundView = selectView
            
            eggTypeCell.eggName.text = eggNames[indexPath.row]
            eggTypeCell.eggIcon.image = UIImage(named: eggIcons[indexPath.row])
            
            if indexPath.row == userEggChoose
            {
                eggTypeCell.accessoryType = .checkmark
            }
            
            return eggTypeCell
        }
        
        let soundCell = tableView.dequeueReusableCell(withIdentifier: "soundCell")
        soundCell?.selectedBackgroundView = selectView
        soundCell?.textLabel?.text = notificationSoundsNames[indexPath.row]
        
        if indexPath.row == userSoundChoose
        {
            soundCell?.accessoryType = .checkmark
        }
        
        return soundCell!
    }
    
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var name = ""
        switch section {
        case 0: name = NSLocalizedString("Egg type", comment: "Egg type")
        case 1: name = NSLocalizedString("Notification sound", comment: "Notification sound")
        default:
            print ("Error sections")
        }
        
        return name
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        
        view.tintColor = lightGrayColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
        header.textLabel?.font = UIFont(name: "System", size: 10)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section
        {
        case 0:
            for index in 0..<4
            {
                tableView.cellForRow(at: [0, index])?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            userDefaults.set(indexPath.row, forKey: "userEggChoose")
        case 1:
            for index in 0..<5
            {
                tableView.cellForRow(at: [1, index])?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            userDefaults.set(indexPath.row, forKey: "userSoundChoose")
            notificationForSound()
        default: print("Checkmark error!")
        }
        userDefaults.synchronize()
    }
    
    func loadFromUserDefaults()
    {
        if userDefaults.value(forKey: "userEggChoose") != nil
        {
            userEggChoose = userDefaults.value(forKey: "userEggChoose") as! Int
        }
        
        if userDefaults.value(forKey: "userSoundChoose") != nil
        {
           userSoundChoose = userDefaults.value(forKey: "userSoundChoose") as! Int
        }
    }

    func notificationForSound()
    {
        let alert = UIAlertController(title: "Sound", message: "No sound in demo mode", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
