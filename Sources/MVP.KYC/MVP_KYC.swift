import UIKit
import Foundation

public struct MVP_KYC {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}


final public class VerrifWrapper {
    let url: String
    private(set) var logo: UIImage?
    private(set) var bulletPointImg: UIImage?
    private(set) var themeColor: UIColor = UIColor.green
    private(set) var backgroundColor: UIColor = .white
    private(set) var locale: Locale = Locale.ukLocale
    private(set) var didSuccess: (() -> Void)?
    private(set) var didFail: (() -> Void)?
    private(set) var didCencel: (() -> Void)?
    
    public init(sessionUrl: String) {
        url = sessionUrl
    }
    
    @discardableResult
    public func setLogo(_ logo: UIImage) -> VerrifWrapper {
        self.logo = logo
        return self
    }
    @discardableResult
    public func setColor(_ color: UIColor) -> VerrifWrapper {
        self.themeColor = color
        return self
    }
    @discardableResult
    public func setBackgroundColor(_ color: UIColor) -> VerrifWrapper {
        self.backgroundColor = color
        return self
    }
    @discardableResult
    public func bulletPointImg(_ img: UIImage) -> VerrifWrapper {
        self.bulletPointImg = img
        return self
    }
    @discardableResult
    public func setLocale(_ locale: Locale) -> VerrifWrapper {
        self.locale = locale
        return self
    }
    @discardableResult
    public func setSuccessAction(_ action: @escaping () -> Void) -> VerrifWrapper {
        self.didSuccess = action
        return self
    }
    @discardableResult
    public func setFailAction(_ action: @escaping () -> Void) -> VerrifWrapper {
        self.didFail = action
        return self
    }
    @discardableResult
    public func setCancelAction(_ action: @escaping () -> Void) -> VerrifWrapper {
        self.didCencel = action
        return self
    }
    public func startSession() {
        let branding = VeriffSdk.Branding(themeColor: themeColor, logo: logo)
        branding.primaryButtonBackgroundColor = themeColor
        branding.bulletPoint = bulletPointImg
        branding.buttonCornerRadius = 8
        let configuration = VeriffSdk.Configuration(branding: branding, languageLocale: locale)
        let veriff = VeriffSdk.shared
        veriff.delegate = self
        veriff.startAuthentication(sessionUrl: url, configuration: configuration)
    }
    
}


extension VerrifWrapper: VeriffSdkDelegate {
    public func sessionDidEndWithResult(_ result: Veriff.VeriffSdk.Result) {
        switch result.status {
        case .done:
            didSuccess?()
        case .canceled:
            didCencel?()
        case .error:
            didFail?()
        @unknown default:
            fatalError()
        }
    }
}
extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
