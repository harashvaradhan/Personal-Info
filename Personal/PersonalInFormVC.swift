//
//  ViewController.swift
//  Personal
//
//  Created by HARSHAVARDHAN EDKE on 01/12/17.
//  Copyright © 2017 HARSHAVARDHAN EDKE. All rights reserved.
//

import UIKit
import CoreData

class PersonalInFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    //MARK: Outlets and Variables
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtHighestDegree: UITextField!
    @IBOutlet weak var txtPassingYear: UITextField!
    @IBOutlet weak var txtGrade: UITextField!
    @IBOutlet weak var txtSchool: UITextField!
    @IBOutlet weak var txtHobbies: UITextField!
    @IBOutlet weak var txtFavouriteColor: UITextField!
    @IBOutlet weak var txtFavouritePlace: UITextField!
    @IBOutlet weak var txtFavouriteFood: UITextField!
    //@IBOutlet weak var txtFavouriteFood: UITextField!
    
    let imagePicker = UIImagePickerController()
    var personalInfo:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MARK: Set delegates for textfield
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtHighestDegree.delegate = self
        self.txtPassingYear.delegate = self
        self.txtGrade.delegate = self
        self.txtSchool.delegate = self
        self.txtHobbies.delegate = self
        self.txtFavouritePlace.delegate = self
        self.txtFavouriteFood.delegate = self
        self.txtFavouriteColor.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fetchInfo()
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PersonalInFormVC.imageTapped))
        self.imgProfileImage.isUserInteractionEnabled = true
        self.imgProfileImage.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialseForm() {
        self.txtFirstName.text = ""
        self.txtLastName.text = ""
        self.txtHighestDegree.text = ""
        self.txtPassingYear.text = ""
        self.txtGrade.text = ""
        self.txtSchool.text = ""
        self.txtHobbies.text = ""
        self.txtFavouritePlace.text = ""
        self.txtFavouriteFood.text = ""
        self.txtFavouriteColor.text = ""
        self.imgProfileImage.image = UIImage(named:"user-icon")
    }
    
    func fetchInfo() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonalInfo")
        request.returnsObjectsAsFaults = false
        do {
            self.personalInfo = try context.fetch(request)
            for data in self.personalInfo as! [NSManagedObject] {
                self.txtFirstName.text = data.value(forKey: "firstname") as? String
                self.txtLastName.text = data.value(forKey: "lastname") as? String
                self.txtHighestDegree.text = data.value(forKey: "highestdegree") as? String
                self.txtPassingYear.text = data.value(forKey: "passingyear") as? String
                self.txtGrade.text = data.value(forKey: "grade") as? String
                self.txtSchool.text = data.value(forKey: "school") as? String
                self.txtHobbies.text = data.value(forKey: "hobbies") as? String
                self.txtFavouritePlace.text = data.value(forKey: "favouriteplace") as? String
                self.txtFavouriteFood.text = data.value(forKey: "favouritefood") as? String
                self.txtFavouriteColor.text = data.value(forKey: "favouritecolor") as? String
                self.imgProfileImage.image = UIImage.init(data: data.value(forKey: "profileimage") as! Data)
            }
            
        } catch {
            print("Failed")
        }
    }
    
    //MARK: Button Actions
    @IBAction func onSave(_ sender: Any) {
        var flag:Int =  1
        if self.txtFirstName.text == "" {
            self.showAlertWithMessage(messageText: "First name field is mandatory", fromView: self)
            flag = 0
        }
        if self.txtLastName.text == "" {
            self.showAlertWithMessage(messageText: "Last name field is mandatory", fromView: self)
            flag = 0
        }
        if self.txtHighestDegree.text == "" {
            self.showAlertWithMessage(messageText: "Highest degree field is mandatory", fromView: self)
            flag = 0
        }
        if self.txtPassingYear.text == "" {
            self.showAlertWithMessage(messageText: "Passing Year field is mandatory", fromView: self)
            flag = 0
        }
        if self.txtGrade.text == "" {
            self.showAlertWithMessage(messageText: "Grade field is mandatory", fromView: self)
            flag = 0
        }
        if self.txtSchool.text == "" {
            self.showAlertWithMessage(messageText: "School/college field is mandatory", fromView: self)
            flag = 0
        }
        if self.txtHobbies.text == "" {
            self.showAlertWithMessage(messageText: "Hobbies field is mandatory", fromView: self)
            flag = 0
        }
        if flag == 1 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "PersonalInfo", in: context)
            let personalInfo = NSManagedObject(entity: entity!, insertInto: context)
            personalInfo.setValue(self.txtFirstName.text, forKey: "firstname")
            personalInfo.setValue(self.txtLastName.text, forKey: "lastname")
            personalInfo.setValue(self.txtHighestDegree.text, forKey: "highestdegree")
            personalInfo.setValue(self.txtPassingYear.text, forKey: "passingyear")
            personalInfo.setValue(self.txtGrade.text, forKey: "grade")
            personalInfo.setValue(self.txtSchool.text, forKey: "school")
            personalInfo.setValue(self.txtHobbies.text, forKey: "hobbies")
            personalInfo.setValue(self.txtFavouritePlace.text, forKey: "favouriteplace")
            personalInfo.setValue(self.txtFavouriteFood.text, forKey: "favouritefood")
            personalInfo.setValue(self.txtFavouriteColor.text, forKey: "favouritecolor")
            
            guard let imageData = UIImageJPEGRepresentation(self.imgProfileImage.image!, 1) else {
                print("jpg error")
                return
            }
            personalInfo.setValue(imageData,forKey:"profileimage")
            do {
                try context.save()
                self.showAlertWithMessage(messageText: "Information saved successfully", fromView: self)
            } catch {
                print("Failed saving")
            }
        }
    }
    
    @IBAction func onUpdate(_ sender: Any) {
        self.onSave(sender)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        for data in self.personalInfo as! [NSManagedObject] {
            context .delete(data)
        }
        do {
            try context.save()
            DispatchQueue.main.async {
                self.initialseForm()
                self.showAlertWithMessage(messageText: "Information deleted successfully", fromView: self)
            }
        } catch {
            print("Failed saving")
        }
        
    }
    
    //MARK: Getsture recognizer
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: UIImagePicker Delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imgProfileImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Show alert
    func showAlertWithMessage(messageText message:String, fromView viewReference:AnyObject?) -> Void {
        DispatchQueue.main.async(execute: {
            let alertViewCont:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            viewReference!.present(alertViewCont, animated: true, completion: nil)
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                alertViewCont.dismiss(animated: true, completion: nil)
            })
        })
    }
    //MARK: UITextField Delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFirstName {
            self.txtLastName.becomeFirstResponder()
        }else if textField == self.txtLastName {
            self.txtHighestDegree.becomeFirstResponder()
        }else if textField == self.txtHighestDegree {
            self.txtPassingYear.becomeFirstResponder()
        }else if textField == self.txtPassingYear {
            self.txtGrade.becomeFirstResponder()
        }else if textField == self.txtGrade {
            self.txtSchool.becomeFirstResponder()
        }else if textField == self.txtSchool {
            self.txtHobbies.becomeFirstResponder()
        }else if textField == self.txtHobbies {
            self.txtFavouriteColor.becomeFirstResponder()
        }else if textField == self.txtFavouriteColor {
            self.txtFavouritePlace.becomeFirstResponder()
        }else if textField == self.txtFavouritePlace {
            self.txtFavouriteFood.becomeFirstResponder()
        }else if textField == self.txtFavouriteFood {
            self.txtFavouriteFood.resignFirstResponder()
        }
        
        return true
    }
}
