//
//  ResultCell.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var visibility: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ result: Weather) {
        name.text = result.name
        weatherDescription.text = result.description
        let speed = String(result.wind["speed"]!)
        let degree = String(result.wind["deg"]!)
        wind.text = "Speed: \(speed), Degree: \(degree)"
        visibility.text = "Visibility: \(String(result.visibility))"
    }

}
