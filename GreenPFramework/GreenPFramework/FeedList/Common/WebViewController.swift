//
//  WebViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/17.
//

import UIKit
import WebKit

class WebViewController : BaseViewController {
    public var urlAddress: String = "google.com"
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    convenience init(url: String) {
        self.init()
        self.urlAddress = url
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("DeInit : \(String(describing: self))")
    }
    
    // MARK: Setup UI properties
    
    public lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        
        let processPool: WKProcessPool = WKProcessPool()
        configuration.processPool = processPool
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
        setupLayoutConstraints()
        initView()
        setupActions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: urlAddress) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(URLRequest(url: url))
        }
    }
    
    // MARK: Main
    
    /// Initialize constraints
    private func setupLayoutConstraints() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        webView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// Initialize properties
    private func initView() {
        configureCloseButton()
        view.backgroundColor = .white
    }
    
    /// Initialize actions
    private func setupActions() {
    }
}

extension WebViewController : WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        alert(message: message, confirmTitle: "확인", cancelTitle: "취소")
        completionHandler()
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        alert(message: message, confirmTitle: "확인", confirmHandler: { _ in
            completionHandler(true)
        }, cancelTitle: "취소") { _ in
            completionHandler(false)
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString == "about:blank" {
                decisionHandler(.cancel)
            } else if url.scheme != "http" && url.scheme != "https" {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else { return nil }

        if navigationAction.targetFrame == nil {
            if url.description.lowercased().range(of: "http://") != nil ||
                url.description.lowercased().range(of: "https://") != nil ||
                url.description.lowercased().range(of: "mailto:") != nil {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
        } else {
            present(WebViewController(url: url.absoluteString), animated: true)
        }
        return nil
    }
}
