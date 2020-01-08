import Foundation
import Capacitor
import AuthenticationServices


class GetAppleSignInHandler: NSObject, ASAuthorizationControllerDelegate {
   
  var call: CAPPluginCall
  var identityTokenString :String?
    var window : UIWindow;
    init(call: CAPPluginCall,window:UIWindow) {
    self.call = call
    self.window = window
    super.init()
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
               
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
}
  
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
         // error.localizedDescription
           print("Error - \(error.localizedDescription)")
        call.error(error.localizedDescription, error, [
             "message": error.localizedDescription
           ])
      }
      
      func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
          if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
              
             
              print("User Id - \(appleIDCredential.user)")
              print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
              print("User Email - \(appleIDCredential.email ?? "N/A")")
              print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
              if let identityTokenData = appleIDCredential.identityToken,
                  let theIdentityTokenString = String(data: identityTokenData, encoding: .utf8) {
                  print("Identity Token \(theIdentityTokenString)")
                  self.identityTokenString = theIdentityTokenString
              }
              let infoData: [String: Any] = [
                  "user": appleIDCredential.user,
                  "fullName": appleIDCredential.fullName?.description ?? "N/A",
                  "email": appleIDCredential.email ?? "N/A",
                  "realUserStatus": appleIDCredential.realUserStatus.rawValue,
                  "identityTokenString": self.identityTokenString as Any
              ];
            call.success(infoData)
              
          } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
              // Sign in using an existing iCloud Keychain credential.
              let username = passwordCredential.user
              let password = passwordCredential.password
              let infoData: [String: Any] = [
                             "username": username,
                             "password": password
              ];
             call.success(infoData)
              
          }
      }
  
     
}

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(DemoCapacitor)
public class DemoCapacitor: CAPPlugin {
    var signInHandler: GetAppleSignInHandler?
    
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
    
    @objc func showAppleLogin(_ call: CAPPluginCall) {
      
        print("On call apple provider")
        DispatchQueue.main.async {
            self.signInHandler = GetAppleSignInHandler(call: call, window: (self.bridge?.getWebView()?.window)!)
        }
  }
}

extension GetAppleSignInHandler: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
         print("On call presentationAnchor")
        return self.window
  }
}

