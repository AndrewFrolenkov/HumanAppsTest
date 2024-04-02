//
//  FirstViewController.swift
//  HumanAppsTest
//
//  Created by Андрей Фроленков on 1.04.24.


import UIKit


final class FirstViewController: UIViewController {
  
  // MARK: - ViewModel
  var viewModel: FirstViewModelProtocol
  
  // MARK: - UI
  private lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var cropAreaView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var yellowBorderView: UIView = {
    let view = UIView()
    view.layer.borderColor = UIColor.yellow.cgColor
    view.layer.borderWidth = 2.0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var addButton: UIButton = {
    let addButton = UIButton(type: .contactAdd)
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    return addButton
  }()
  
  // MARK: - Supporting
  private var initialPanPoint: CGPoint = .zero
  private var originalImage: UIImage?
  
  // MARK: - Initilize
  init(viewModel: FirstViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.viewModel.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addSubviews()
    layout()
    addTap()
    setupNavigationBar()
    
    yellowBorderView.isHidden = true
    
    view.backgroundColor = .white
  }
  
  // MARK: - SetUI
  // MARK: - ConfigureNavigationBar
  private func setupNavigationBar() {
    let saveButton = UIButton(type: .system)
    saveButton.setImage(UIImage(systemName: "opticaldiscdrive"), for: .normal)
    saveButton.tintColor = .black
    saveButton.setTitle("Save", for: .normal)
    saveButton.setTitleColor(.black, for: .normal)
    saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    saveButton.sizeToFit()
    
    let saveBarButton = UIBarButtonItem(customView: saveButton)
    navigationItem.rightBarButtonItem = saveBarButton
    navigationItem.rightBarButtonItem?.isHidden = true
    
    let segmentedControl = UISegmentedControl(items: ["Цветное", "Ч/Б"])
    segmentedControl.selectedSegmentIndex = 0 // Устанавливаем по умолчанию на цветное
    segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    
    let segmentedBarButton = UIBarButtonItem(customView: segmentedControl)
    navigationItem.leftBarButtonItem = segmentedBarButton
    navigationItem.leftBarButtonItem?.isHidden = true
  }
  
  // MARK: - AddSubviews
  private func addSubviews() {
    view.addSubview(cropAreaView)
    view.addSubview(addButton)
    cropAreaView.addSubview(imageView)
    cropAreaView.addSubview(yellowBorderView)
  }
  
  // MARK: - Layout
  private func layout() {
    NSLayoutConstraint.activate([
      addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      cropAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      cropAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      cropAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      cropAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      imageView.topAnchor.constraint(equalTo: cropAreaView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor),
      
      yellowBorderView.centerXAnchor.constraint(equalTo: cropAreaView.centerXAnchor),
      yellowBorderView.centerYAnchor.constraint(equalTo: cropAreaView.centerYAnchor),
      yellowBorderView.widthAnchor.constraint(equalTo: cropAreaView.widthAnchor, multiplier: 0.5),
      yellowBorderView.heightAnchor.constraint(equalTo: cropAreaView.heightAnchor, multiplier: 0.5)
    ])
  }
  
  
  // MARK: - Actions
  // segmentedControlValueChanged
  @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    guard let image = imageView.image else { return }
    
    let context = CIContext(options: nil)
    let ciImage = CIImage(image: image)
    
    switch sender.selectedSegmentIndex {
    case 0: // Цветное изображение
      if let original = originalImage {
        imageView.image = original
      }
    case 1: // Черно-белое изображение
      if let ciImage = ciImage {
        originalImage = image // Сохраняем исходное изображение
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter?.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
          imageView.image = UIImage(cgImage: cgImage)
        }
      }
    default:
      break
    }
  }
  
  // SavePhoto
  @objc private func saveButtonTapped() {
    guard let image = imageView.image else { return }
    
    // Получаем размеры изображения и рамки в пределах imageView
    let imageSize = imageView.bounds.size
    let frameSize = yellowBorderView.bounds.size
    
    // Получаем пропорции масштабирования между изображением и imageView
    let scaleWidth = image.size.width / imageSize.width
    let scaleHeight = image.size.height / imageSize.height
    
    // Получаем координаты и размеры рамки в пределах изображения
    let rect = CGRect(x: yellowBorderView.frame.origin.x * scaleWidth,
                      y: yellowBorderView.frame.origin.y * scaleHeight,
                      width: frameSize.width * scaleWidth,
                      height: frameSize.height * scaleHeight)
    
    // Обрезаем изображение по рамке
    guard let croppedImage = image.cgImage?.cropping(to: rect) else { return }
    
    // Создаем UIImage из обрезанного CGImage
    let finalImage = UIImage(cgImage: croppedImage)
    
    // Сохраняем обрезанное изображение в галерею
    UIImageWriteToSavedPhotosAlbum(finalImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      // Ошибка при сохранении фото
      print("Ошибка сохранения фото: \(error.localizedDescription)")
    } else {
      // Фото успешно сохранено
      let alert = UIAlertController(title: "Сохранено", message: "Фотография успешно сохранена в галерее", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
      
      // Сбросить изображение на nil
      imageView.image = nil
      
      // Скрыть желтую рамку
      yellowBorderView.isHidden = true
      
      // Сделать кнопку "Добавить" видимой снова
      addButton.isHidden = false
      
      navigationItem.rightBarButtonItem?.isHidden = true
      navigationItem.leftBarButtonItem?.isHidden = true
    }
  }
  
  @objc private func addButtonTapped() {
    viewModel.addButtonTapped(presenter: self)
  }
  
  // MARK: - Taps
  private func addTap() {
    // Добавляем обработчики жестов для cropAreaView
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    cropAreaView.addGestureRecognizer(panGesture)
    
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
    cropAreaView.addGestureRecognizer(pinchGesture)
    
    let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
    cropAreaView.addGestureRecognizer(rotationGesture)
  }
  
  // MARK: - ActionTap
  // Перемещение рамки
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    guard imageView.image != nil else { return }
    
    let translation = gesture.translation(in: yellowBorderView.superview)
    switch gesture.state {
    case .began:
      initialPanPoint = yellowBorderView.center
    case .changed:
      let newCenter = CGPoint(x: initialPanPoint.x + translation.x, y: initialPanPoint.y + translation.y)
      yellowBorderView.center = newCenter
    default:
      break
    }
  }
  
  // Масштабирование фото
  @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
    guard imageView.image != nil else { return } // Проверяем наличие изображения
    
    if gesture.state == .changed {
      let currentTransform = imageView.transform
      var newTransform = currentTransform.scaledBy(x: gesture.scale, y: gesture.scale)
      
      // Проверяем, чтобы новый масштаб не превышал максимальный
      let maxScale: CGFloat = 3.0
      let minScale: CGFloat = 1.0
      let currentScale = sqrt(abs(newTransform.a * newTransform.d - newTransform.b * newTransform.c))
      
      if currentScale < minScale {
        let scale = minScale / currentScale
        newTransform = newTransform.scaledBy(x: scale, y: scale)
      } else if currentScale > maxScale {
        let scale = maxScale / currentScale
        newTransform = newTransform.scaledBy(x: scale, y: scale)
      }
      
      imageView.transform = newTransform
      gesture.scale = 1.0
    }
  }
  
  // Вращение фото
  @objc private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
    guard imageView.image != nil else { return } // Проверяем наличие изображения
    
    switch gesture.state {
    case .changed:
      imageView.transform = imageView.transform.rotated(by: gesture.rotation)
      gesture.rotation = 0
    default:
      break
    }
  }
  
  
  // MARK: - ChooseImage
  // Срабатывает после выбора изображения
  private func handlePickedImage(_ image: UIImage) {
    imageView.image = image
    addButton.isHidden = true // Скрыть кнопку после выбора изображения
    yellowBorderView.isHidden = false
    navigationItem.rightBarButtonItem?.isHidden = false
    navigationItem.leftBarButtonItem?.isHidden = false
    
    
    updateYellowBorderViewFrame()
  }
  
  // Функция для обновления размеров рамки yellowBorderView
  private func updateYellowBorderViewFrame() {
    // Устанавливаем размеры рамки yellowBorderView такие же как у cropAreaView
    yellowBorderView.frame = cropAreaView.bounds
  }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension FirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    
    if let pickedImage = info[.originalImage] as? UIImage {
      viewModel.handlePickedImage(pickedImage)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - FirstViewModelDelegate
extension FirstViewController: FirstViewModelDelegate {
  func didSelectImage(_ image: UIImage) {
    handlePickedImage(image)
  }
}



