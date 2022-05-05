//
//  Encriptation.swift
//  HotelXcaretMexico
//
//  Created by Jairo López Gutiérrez on 21/04/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import Foundation

class Encriptation {
    private static var _Encriptation : Encriptation!
    public static var shared: Encriptation{
        if _Encriptation == nil{
            _Encriptation = Encriptation()
        }
        return _Encriptation
    }
    
    func encript(encript: String)-> String?{
        
        let publicKey : String = appDelegate.bookingConfig.public_key_rsa!// "MIICITANBgkqhkiG9w0BAQEFAAOCAg4AMIICCQKCAgBspPSAd3/7c6Fr2EtXFCKynQnmeaOHxVzd/uv+reWRISClNjcg3vJhCtSMkRv2ViyhSaqhsactLzEYqnj/qnhjuuKoO6PLdy7reJ/O0Vc4Fv+mqKeVja64adsPnPtykz2fXzYlvQS5sefrBUQ+ZItd/Ztqsd7g+dIhSI15x5wBmw1TaN4uUtIpKdTv7lCnQrYhOtBdHmWfWGqMFDQhiw6uNoPp6pw9y6SapW6tUO7drBCIqFx253xOBwbqyVg6WW4OB6AfZyrnAmqajR9YLQYO1RUX0DkhPxpuK5ywx4lKHmBgJ1TQVKQLVLUfLpbQXw3WZk5xoQu+yNPlixksaHTxk2DYP82pHjwb9boYdzpY7PJx6DzZPMEmkSasfAOkRNBc8zN1U4JXWypx1PZbvsv+fAu7E+Iv45BMFl8r6ZncacsG/qfyuuAdPFiowGm0RuNPCIufX/87M3jtuMQHlqkmRA2Rwcm+FiZ/rrDcrhFdnyD7eFqgfMQkc72Z1ZTUWTVIQtVJkPvKu7rm9aTqMrVM/7yAX5JpED9rdBYfB/yyB2k3SIPfVqdTTdRapEC+/OwxGoPAi2JkSDxAqDUMef2yBEULGB0UkQ8cpt+ntIC0VVE1A1qcqBj9h8za+G+2noQqwiIUAh4tiVBWh5feICEP9t9GYW/uwrQZ7W2iggNGtwIDAQAB"
        
        if let enc = RSA.encrypt(string: encript, publicKey: publicKey){
            return enc
        }else{
            return nil
        }
    }
    
    struct RSA {
        
        static func encrypt(string: String, publicKey: String?) -> String? {
            
            guard let publicKey = publicKey else { return nil }
            
            let keyString = publicKey.replacingOccurrences(of: "-----BEGIN RSA PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END RSA PUBLIC KEY-----", with: "")
            
            guard let data = Data(base64Encoded: keyString) else { return nil }
            
            var attributes: CFDictionary {
                return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                        kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                        kSecAttrKeySizeInBits   : 2048,
                        kSecReturnPersistentRef : true] as CFDictionary
            }
            
            var error: Unmanaged<CFError>? = nil
            
            guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
                print(error.debugDescription)
                return nil
            }
            
            return encrypt(string: string, publicKey: secKey)
        }
        
        static func encrypt(string: String, publicKey: SecKey) -> String? {
            let buffer = [UInt8](string.utf8)
            var keySize   = SecKeyGetBlockSize(publicKey)
            var keyBuffer = [UInt8](repeating: 0, count: keySize)
            
            // Encrypto  should less than key length
            guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
            
            return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
        }
        
    }
}
