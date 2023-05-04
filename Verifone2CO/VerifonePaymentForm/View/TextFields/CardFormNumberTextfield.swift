//
//  CardFormNumberTextfield.swift
//  Verifone2CO
//

import UIKit

public class CardFormNumberTextField: BaseTextField {
    
    // MARK: - Properties
    fileprivate var previousTextFieldContent: String?
    fileprivate var previousSelection: UITextRange?
    fileprivate var _delegate: UITextFieldDelegate?

    public var getNumbers: String? {
        get {
            return self.text?.replacingOccurrences(of: " ", with: "", options: .literal)
        }
    }
    public var cardBrand: String? {
        return CardValidator.getCardType(text!)?.getName()
    }

    public override var delegate: UITextFieldDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override init() {
        super.init(frame: CGRect.zero)
        configure()
    }

    private func configure() {
        keyboardType = .numberPad
        super.delegate = self
        placeholder = placeholder
        textContentType = .creditCardNumber
    }

    public override func validateAndThrowError() throws {
        guard !self.text!.isEmpty else {
            throw VF2COValidationError.requiredInput
        }
        if !CardValidator.validateCardNumber(self.text!) {
            throw VF2COValidationError.invalidData
        }
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}

extension CardFormNumberTextField: UITextFieldDelegate {
    override func textFieldDidChange() {
        formattedCardNumber(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text
        previousSelection = textField.selectedTextRange
        return true
    }

    public func removeNonDigits(_ string: String, cursorPosition: inout Int) -> String {
        let originalCursorPosition = cursorPosition
        let digits = CharacterSet.decimalDigits
        var digitsOnlyString = ""

        for (index, character) in string.enumerated() {
            if digits.contains(character.unicodeScalars.first!) {
                digitsOnlyString.append(character)
            } else if index < originalCursorPosition {
                cursorPosition -= 1
            }
        }

        return digitsOnlyString
    }

    // Get formatted card number
    public func formattedCardNumber(_ textField: UITextField) {
        // Get the card type based on the current text in the text field
        let card = CardValidator.getCardType(textField.text!)
        // Get the current cursor position and the text in the text field
        guard let selectedRange = textField.selectedTextRange, let textString = textField.text else { return }
        var targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        // Remove all non-digit characters from the text
        let cardNumber = removeNonDigits(textString, cursorPosition: &targetCursorPosition)
        // If the card type is set and the card number is too long, restore the previous text and cursor position
        if card != nil && cardNumber.count > card!.cardLength.upperBound {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        // Insert spaces every four digits
        let formattedCardNumber = insertSpaces(cardNumber, cursorPosition: &targetCursorPosition)
        // Update the text field with the modified text
        textField.text = formattedCardNumber
        // Update the cursor position
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }

    public func insertSpaces(_ string: String, cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        for i in 0..<string.count {
            if ((i > 0) && ((i % 4) == 0)) {
                stringWithAddedSpaces += " "
                if (i < cursorPositionInSpacelessString) {
                    cursorPosition += " ".count
                }
            }
            stringWithAddedSpaces.append(string[string.index(string.startIndex, offsetBy: i)])
        }
        return stringWithAddedSpaces
    }
}
