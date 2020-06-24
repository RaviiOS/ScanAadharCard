//
//  BarCodeParser.swift
//  BarCodeScanDemo
//
//  Created by Ravi Kumar Yaganti on 11/06/20.
//  Copyright © 2020 Ravi Kumar Yaganti. All rights reserved.
//

import Foundation
class AadharAP{
    var uid: String
    var name: String
    var gender: String
    var yob: String
    var co: String
    var house: String
    var loc: String
    var vtc: String
    var dist: String
    var state: String
    var pc: String
    var dob: String

    init?(dictionary: [String : String]) {
        guard let uid = dictionary["uid"],
            let name = dictionary["name"],
            let gender = dictionary["gender"],
            let yob = dictionary["yob"],
            let co = dictionary["co"],
            let loc = dictionary["loc"],
            let house = dictionary["house"],
            let vtc = dictionary["vtc"],
            let dist = dictionary["dist"],
            let state = dictionary["state"],
            let pc = dictionary["pc"],
            let dob = dictionary["dob"] else {
            return nil
        }

        self.uid = uid
        self.name = name
        self.gender = gender
        self.yob = yob
        self.co = co
        self.house = house
        self.loc = loc
        self.vtc = vtc
        self.dist = dist
        self.state = state
        self.pc = pc
        self.dob = dob
    }

}
class BarcodeData {
    var uid: String
    var name: String
    var gender: String
    var yob: String
    var co: String
    var house: String
    var street: String
    var lm: String
    var vtc: String
    var po: String
    var dist: String
    var subdist: String
    var state: String
    var pc: String
    var dob: String

    init?(dictionary: [String : String]) {
        guard let uid = dictionary["uid"],
            let name = dictionary["name"],
            let gender = dictionary["gender"],
            let yob = dictionary["yob"],
            let co = dictionary["co"],
            let house = dictionary["house"],
            let street = dictionary["street"],
            let lm = dictionary["lm"],
            let vtc = dictionary["vtc"],
            let po = dictionary["po"],
            let dist = dictionary["dist"],
            let subdist = dictionary["subdist"],
            let state = dictionary["state"],
            let pc = dictionary["pc"],
            let dob = dictionary["dob"] else {
            return nil
        }

        self.uid = uid
        self.name = name
        self.gender = gender
        self.yob = yob
        self.co = co
        self.house = house
        self.street = street
        self.lm = lm
        self.vtc = vtc
        self.po = po
        self.dist = dist
        self.subdist = subdist
        self.state = state
        self.pc = pc
        self.dob = dob

    }
}

class MyParser: NSObject {
    var parser: XMLParser

    var barcodes = [BarcodeData]()
    var aadharAPData = [AadharAP]()
    init(xml: String) {
        parser = XMLParser(data: xml.data(using: String.Encoding.utf8)!)
        super.init()
        parser.delegate = self
    }

    func parseXML() -> [BarcodeData] {
        parser.parse()
        return barcodes
    }
    
    func parseAPXML() -> [AadharAP]{
        parser.parse()
        return aadharAPData
    }

}

extension MyParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

        if elementName == "PrintLetterBarcodeData" {
            
            if let barcode = BarcodeData(dictionary: attributeDict) {
                barcodes.append(barcode)
            }else{
                if let barcodeData = AadharAP(dictionary: attributeDict){
                    aadharAPData.append(barcodeData)
                }
            }
        }
    }
}
