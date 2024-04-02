//
//  FirstViewModel.swift
//  HumanAppsTest
//
//  Created by Андрей Фроленков on 1.04.24.
//

import Foundation
import UIKit

protocol FirstViewModelDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

protocol FirstViewModelProtocol {
    var delegate: FirstViewModelDelegate? { get set }
    func addButtonTapped(presenter: UIViewController)
    func handlePickedImage(_ image: UIImage)
}

class FirstViewModel: FirstViewModelProtocol {
    weak var delegate: FirstViewModelDelegate?
    
    func addButtonTapped(presenter: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = presenter as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        
        presenter.present(imagePicker, animated: true, completion: nil)
    }
    
    func handlePickedImage(_ image: UIImage) {
        delegate?.didSelectImage(image)
    }
}
