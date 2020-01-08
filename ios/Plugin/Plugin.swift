import Foundation
import Capacitor
import AuthenticationServices
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(DemoCapacitor)
public class DemoCapacitor: CAPPlugin {
    
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
  var signInCall: CAPPluginCall?
    var identityTokenString : String?
              
    
    @objc func showAppleLogin(_ call: CAPPluginCall) {
      signInCall = call;
    print("On call apple provider")
    let appleIDProvider = ASAuthorizationAppleIDProvider()
             let request = appleIDProvider.createRequest()
             request.requestedScopes = [.fullName, .email]
             
             let authorizationController = ASAuthorizationController(authorizationRequests: [request])
             authorizationController.delegate = self
             authorizationController.presentationContextProvider = self
             authorizationController.performRequests()
    }

    
    private func performExistingAccountSetupFlows() {
         print("On call performExistingAccountSetupFlows")
          // Prepare requests for both Apple ID and password providers.
          let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
          
          // Create an authorization controller with the given requests.
          let authorizationController = ASAuthorizationController(authorizationRequests: requests)
          authorizationController.delegate = self
          authorizationController.presentationContextProvider = self
          authorizationController.performRequests()
      }
      
   
}


extension DemoCapacitor : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       // error.localizedDescription
         print("Error - \(error.localizedDescription)")
       // self.bridge.triggerWindowJSEvent(eventName: "didCompleteWithError", data: error.localizedDescription)
        signInCall?.error(error.localizedDescription)
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
            signInCall?.success(infoData);
          
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            let infoData: [String: Any] = [
                           "username": username,
                           "password": password
            ];
            signInCall?.success(infoData);
            
        }
    }
}

extension DemoCapacitor: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
         print("On call presentationAnchor")
        return (self.bridge?.getWebView()?.window)!
  }
}

