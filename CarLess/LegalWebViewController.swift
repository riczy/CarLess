import UIKit
import WebKit

class LegalWebViewController: UIViewController {
    
    private var webView = WKWebView()
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        
        if url == nil {
            NSLog("The URL is null; cannot load requested legal content.")
        } else {
            let req = NSURLRequest(URL: NSURL(string: url!)!)
            webView.loadRequest(req)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LegalWebViewController : WKNavigationDelegate {
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("Navigation to \(url) failed: \(error)")
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("Provisional navigation to \(url) failed: \(error)")
    }
}
