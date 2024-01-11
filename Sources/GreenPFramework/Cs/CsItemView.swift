//
//  CsItemView.swift
//
//
//  Created by 신아람 on 1/3/24.
//

import UIKit
import SnapKit

extension CsItemView {
    public func configure(list: [ParticipateListForCs.ParticipateForCs]) {
        self.originCampaignList = list
        
        DispatchQueue.main.async {
            self.setCampaignList(list: list)
        }
    }
}

class CsItemView : UIView, UINavigationControllerDelegate {

    var selectedCampaign = 0
    var selectedFile: URL? = nil
    
    let csTypeList: [String] = ["광고적립 문의", "기타 문의"]
    var campaignList: [ParticipateListForCs.ParticipateForCs] = []
    var originCampaignList: [ParticipateListForCs.ParticipateForCs] = []
    
    let contentPlaceholder = "문의 내용을 구체적으로 작성해 주시면,\n문제 해결을 최대한 빨리 도와드릴 수 있습니다"
    
    var validationMsg = ""
    var onClickSendCs: ((String, SendCsParam?) -> Void)?
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .nanumSquare(size: 14, family: .regular)
        return label
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.font = .nanumSquare(size: 14, family: .regular)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()
    
    let mobileLabel: UILabel = {
        let label = UILabel()
        label.text = "연락처"
        label.font = .nanumSquare(size: 14, family: .regular)
        return label
    }()

    let mobileTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "01012345678"
        textField.keyboardType = .numberPad
        textField.font = .nanumSquare(size: 14, family: .regular)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = .nanumSquare(size: 14, family: .regular)
        return label
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "cs@example.com"
        textField.keyboardType = .emailAddress
        textField.font = .nanumSquare(size: 14, family: .regular)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()

    let campaignLabel: UILabel = {
        let label = UILabel()
        label.text = "문의할 캠페인"
        label.font = .nanumSquare(size: 14, family: .regular)
        return label
    }()
    
    let campaignPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    let campaignTextField: UITextField = {
        let textField = UITextField()
        textField.font = .nanumSquare(size: 14, family: .regular)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()
    
    let csTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "문의 유형"
        label.font = .nanumSquare(size: 14, family: .regular)
        return label
    }()

    let csTypePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let csTypeTextField: UITextField = {
        let textField = UITextField()
        textField.font = .nanumSquare(size: 14, family: .regular)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "문의 내용"
        label.font = .nanumSquare(size: 14, family: .regular)
        return label
    }()

    let contentTextField: UITextView = {
        let textView = UITextView()
        textView.text = "문의 내용을 구체적으로 작성해 주시면,\n문제 해결을 최대한 빨리 도와드릴 수 있습니다"
        textView.textColor = UIColor.lightGray
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.font = .nanumSquare(size: 14, family: .regular)
        
        return textView
    }()
    
    let fileAttachButton: UIButton = {
        let button = UIButton()
        button.setTitle("파일첨부", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.titleLabel?.font = .nanumSquare(size: 14, family: .regular)
        button.addTarget(self, action: #selector(fileAttachButtonTapped), for: .touchUpInside)
        return button
    }()

    let fileAttachInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "10MB 미만의 파일만 첨부 가능합니다."
        label.font = .nanumSquare(size: 9, family: .regular)
        label.textColor = .gray
        return label
    }()
    
    let attachFileLabel: UILabel = {
        let label = UILabel()
        label.text = "첨부파일"
        label.font = .nanumSquare(size: 11, family: .regular)
        label.backgroundColor = .lightGray
        return label
    }()
    
    let replyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "문의에 대한 답변은 등록하신 이메일로 보내드립니다."
        label.font = .nanumSquare(size: 9, family: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // 개인정보 동의 체크박스
    let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 제공 동의"
        label.font = .nanumSquare(size: 14, family: .regular)
        return label
    }()
    
    let privacyCheckbox: UISwitch = {
        let checkbox = UISwitch()
        checkbox.onTintColor = UserInfo.shared.themeColor
        return checkbox
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "문의하기를 이용함에 따라 고객님의 연락처(이름, 연락처, 이메일)을 (주)애드포러스에 제공하며 제공된 정보는 고객문의 해결을 위하여 일시 보관되며, 60이후 파기됩니다."
        label.font = .nanumSquare(size: 9, family: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("문의하기", for: .normal)
        button.titleLabel?.font = .nanumSquare(size: 14, family: .regular)
        button.backgroundColor = UserInfo.shared.themeColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        campaignPickerView.dataSource = self
        campaignPickerView.delegate = self
        csTypePickerView.dataSource = self
        csTypePickerView.delegate = self
        
        contentTextField.delegate = self
        
        setupLayoutConstraints()
        initView()
        addDoneButtonToPickerViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    func addDoneButtonToPickerViews() {

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: false)

        campaignTextField.inputAccessoryView = toolbar
        csTypeTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        self.endEditing(true)
    }
    
    @objc func fileAttachButtonTapped() {
        print("fileAttachButtonTapped")
        
        if let vc = self.parentViewController {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                vc.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @objc func sendButtonTapped() {
        print("sendButtonTapped")
        
        guard let listener = onClickSendCs else {
            return
        }
        
        let param = makeCsParam()
        listener(validationMsg, param)
    }
    
    private func makeCsParam() -> SendCsParam? {
     
        guard let name = nameTextField.text, !name.isEmpty else {
            validationMsg = "이름을 입력해주세요"
            return nil
        }
        
        guard let mobile = mobileTextField.text, mobile.count >= 10, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: mobile)) else {
            validationMsg = "올바른 휴대폰번호를 입력해주세요"
            return nil
        }
        
        guard let email = emailTextField.text, isValidEmail(email: email) else {
            validationMsg = "올바른 이메일주소를 입력해주세요"
            return nil
        }
        
        if let content = contentTextField.text, !content.isEmpty {
            if(content == contentPlaceholder) {
                validationMsg = "내용을 입력해주세요"
                return nil
            }
        } else {
            validationMsg = "내용을 입력해주세요"
            return nil
        }
        
        
        guard let content = contentTextField.text, !content.isEmpty else {
            validationMsg = "내용을 입력해주세요"
            return nil
        }
        
        if(!privacyCheckbox.isOn) {
            validationMsg = "개인정보 제공에 동의해주세요"
            return nil
        }
        
        let csType = csTypePickerView.selectedRow(inComponent: 0)
        let csContent = makeCsContent(csTypePos: csType, email: email, content: content)
        
        let id = selectedCampaign == 0 ? "" : "\(selectedCampaign)"
        let param = SendCsParam(id: id, content: csContent, mobile: mobile, email: email, name: name, file: selectedFile)
        
        validationMsg = ""
        
        return param
    }
    
    private func makeCsContent(csTypePos: Int, email: String, content: String) -> String {
        
        print("makeCsContent")
        
        var csContent = "";
        var csType = "[문의유형] 기타 문의"
        var sep = "\n"
        
        if(csTypePos == 0) {
            csType = "[문의유형] 광고적립 문의"
        }
        
        csContent += (csType + sep)
        csContent += "[답변 이메일] \(email) \(sep)"
        csContent += ("[문의내용] \(content)")
        
        return csContent
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func setCampaignList(list: [ParticipateListForCs.ParticipateForCs]) {
        campaignList = list
        
        if(list.isEmpty) {
            campaignTextField.text = ""
        } else {
            selectedCampaign = campaignList[0].id
            campaignTextField.text = campaignList[0].name
        }
    }
    
    private func setupLayoutConstraints() {

        // 이름
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(nameLabel.intrinsicContentSize.width)
        }

        addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        // 연락처
        addSubview(mobileLabel)
        mobileLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(mobileLabel.intrinsicContentSize.width)
        }

        addSubview(mobileTextField)
        mobileTextField.snp.makeConstraints { make in
            make.top.equalTo(mobileLabel.snp.bottom).offset(8)
            make.left.equalTo(mobileLabel)
            make.right.equalTo(self).offset(-20)
        }

        // 이메일
        addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(mobileTextField.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(emailLabel.intrinsicContentSize.width)
        }

        addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.equalTo(emailLabel)
            make.right.equalTo(self).offset(-20)
        }

        // 캠페인
        addSubview(campaignLabel)
        campaignLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(campaignLabel.intrinsicContentSize.width)
        }

        addSubview(campaignTextField)
        campaignTextField.snp.makeConstraints { make in
            make.top.equalTo(campaignLabel.snp.bottom).offset(8)
            make.left.equalTo(campaignLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        // 문의유형
        addSubview(csTypeLabel)
        csTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(campaignTextField.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(csTypeLabel.intrinsicContentSize.width)
        }

        addSubview(csTypeTextField)
        csTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(csTypeLabel.snp.bottom).offset(8)
            make.left.equalTo(csTypeLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        // 내용
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(csTypeTextField.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(contentLabel.intrinsicContentSize.width)
        }

        addSubview(contentTextField)
        contentTextField.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.left.equalTo(contentLabel)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(120)
        }

        addSubview(fileAttachButton)
        fileAttachButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextField.snp.bottom).offset(8)
            make.left.equalTo(self).offset(20)
        }

        addSubview(fileAttachInfoLabel)
        fileAttachInfoLabel.snp.makeConstraints { make in
//            make.top.equalTo(contentTextField.snp.bottom).offset(4)
            make.centerY.equalTo(fileAttachButton.snp.centerY)
            make.left.equalTo(fileAttachButton.snp.right).offset(10)
        }

        addSubview(attachFileLabel)
        attachFileLabel.snp.makeConstraints { make in
            make.top.equalTo(fileAttachButton.snp.bottom).offset(8)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        addSubview(replyInfoLabel)
        replyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(attachFileLabel.snp.bottom).offset(8)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        
        addSubview(privacyCheckbox)
        privacyCheckbox.snp.makeConstraints { make in
            make.top.equalTo(replyInfoLabel.snp.bottom).offset(8)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(privacyCheckbox.intrinsicContentSize.width)
        }
        
        addSubview(privacyLabel)
        privacyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(privacyCheckbox.snp.centerY)
            make.left.equalTo(privacyCheckbox.snp.right).offset(10)
        }
        
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(privacyCheckbox.snp.bottom).offset(8)
            make.left.equalTo(self).offset(20)
            make.width.equalToSuperview().inset(20)//.inset(40)
        }
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(8)
            make.centerX.equalTo(self)
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
    
    private func initView() {
        backgroundColor = .white
        
        campaignTextField.inputView = campaignPickerView
        csTypeTextField.inputView = csTypePickerView
        csTypeTextField.text = csTypeList[0]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

extension CsItemView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 각 UIPickerView에 따라 데이터 수를 반환
        if pickerView == campaignPickerView {
            return campaignList.count
        } else if pickerView == csTypePickerView {
            return csTypeList.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 각 UIPickerView에 따라 해당하는 데이터 반환
        if pickerView == campaignPickerView {
            return campaignList[row].name
        } else if pickerView == csTypePickerView {
            return csTypeList[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == campaignPickerView {
            selectedCampaign = campaignList[row].id
            let campaign = campaignList[row].name
            campaignTextField.text = campaign
        } else if pickerView == csTypePickerView {
            let csType = csTypeList[row]
            
            if(row == 1) {
                selectedCampaign = 0
                setCampaignList(list: [])
            } else {
                setCampaignList(list: originCampaignList)
            }
            
            csTypeTextField.text = csType
        }
    }
}

extension CsItemView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = contentPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

extension CsItemView: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let imageURL = info[.imageURL] as? URL {
            let fileName = imageURL.lastPathComponent
            print("File Name: \(fileName)")
            
            selectedFile = imageURL
            attachFileLabel.text = fileName
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        selectedFile = nil
        attachFileLabel.text = ""
    }
}

extension CsItemView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
