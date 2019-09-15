//
//  ContainerViewController.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/14.
//  Copyright © 2019 Teemo. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    static let menuWidth: CGFloat = 300
    var menuController: MenuController
    var isMenuOpen: Bool = false
    private var _contentViewController: UIViewController?
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    var albumManager = AlbumManager.shared
    var contentViewController: UIViewController? {
        set {
            if newValue != _contentViewController {
                _contentViewController?.willMove(toParent: nil)
                _contentViewController?.view.removeFromSuperview()
                _contentViewController?.removeFromParent()
                _contentViewController = newValue
                addChild(_contentViewController!)
                view.addSubview(_contentViewController!.view)
            }
        }
        get {
            return _contentViewController
        }
    }
    var viewControllers: Array<UINavigationController>?
    
    init() {
        albumManager.accessPhotos()
        albumManager.fetchAlbum()
        menuController = MenuController(model: albumManager.menuModel!)
        super.init(nibName: nil, bundle: nil)
        menuController.container = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        initializeGesture()
    }
    
    func initializeGesture() {
        self.swipeGestureLeft.addTarget(self, action: #selector(closeMenu))
        self.swipeGestureLeft.direction = .left
        self.swipeGestureRight.addTarget(self, action: #selector(openMenu))
        self.swipeGestureRight.direction = .right
        self.view.addGestureRecognizer(swipeGestureRight)
        self.view.addGestureRecognizer(swipeGestureLeft)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.addMenuController()
        self.addContentControllers()
    }
    
    func addMenuController() {
        addChild(menuController)
        view.addSubview(menuController.view)
    }
    
    func addContentControllers() {
        let allPhotoController = AllPhotoViewController.init(model: albumManager.allPhotoMoedel)
        allPhotoController.container = self
        let navigation = UINavigationController.init(rootViewController: allPhotoController)
        self.viewControllers = [navigation]
        self.contentViewController = navigation
    }
    
    @objc public func openMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentViewController?.view.transform = CGAffineTransform.init(translationX: ContainerViewController.menuWidth, y: 0)
        }) { (finished) in
            self.isMenuOpen = true
        }
    }
    
    @objc public func closeMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentViewController?.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }) { (finished) in
            self.isMenuOpen = false
        }
    }
    
    @objc public func openCloseMenu() {
        if isMenuOpen {
            closeMenu()
        } else {
            openMenu()
        }
    }
    
    @objc public func openContentControllerAtIndexPath(indexPath: IndexPath) {
        
    }

}
