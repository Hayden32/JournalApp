//
//  JournalDetailViewController.swift
//  Jouranl
//
//  Created by Hayden Hastings on 7/31/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var addImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func recordingButtonTapped(_ sender: Any) {
    }
}
