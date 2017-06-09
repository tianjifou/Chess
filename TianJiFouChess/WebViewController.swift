//
//  WebViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/6/9.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {
    var url: URL = URL.init(string: "https://baijiahao.baidu.com/po/feed/share?wfr=spider&for=pc&context=%7B%22sourceFrom%22%3A%22bjh%22%2C%22nid%22%3A%22news_3092406837966608987%22%7D")!
    var webView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "玩法说明"
        self.view.backgroundColor = UIColor.clear
        webView = UIWebView.init(frame: self.view.bounds)
        webView.loadRequest(URLRequest.init(url: url))
        self.view.addSubview(webView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
