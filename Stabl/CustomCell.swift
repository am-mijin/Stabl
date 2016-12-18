//
//  CustomCell.swift


import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    func imageFromColor(colour: UIColor) -> UIImage
    {
        let rect = CGRect(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(colour.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.imageView1.clipsToBounds = true;
        
        //self.imageView1.layer.cornerRadius = 40;
        
        //self.imageView2.clipsToBounds = true;
        
        //self.imageView2.layer.cornerRadius = 40;
        
        
        self.button1.clipsToBounds = true;
        self.button1.layer.cornerRadius = 44;
        self.button2.clipsToBounds = true;
        self.button2.layer.cornerRadius = 44;
        
        
        
        self.button1.setBackgroundImage(self.imageFromColor(colour: UIColor.clear), for:UIControlState.selected )
        self.button2.setBackgroundImage(self.imageFromColor(colour: UIColor.clear), for:UIControlState.selected )
        
        
        self.button1.setBackgroundImage(self.imageFromColor(colour: UIColor(red: 22.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)), for:UIControlState.selected )
        self.button2.setBackgroundImage(self.imageFromColor(colour: UIColor(red: 22.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)), for:UIControlState.selected )
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
