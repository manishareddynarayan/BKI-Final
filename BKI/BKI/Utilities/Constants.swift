//
//  Constants.swift
//  UOVO
//
//  Created by Venu on 17/04/18.
//  Copyright © 2018 UOVO. All rights reserved.
//

import Foundation

var countryCode = "+1"

//MARK: Segue Identifiers

let SIGNINSEGUE = "SignInSegue"
let SIGNUPSEGUE = "SignupSegue"
let FORGOTPWDSEGUE = "ForgotPwdSegue"
let DOCUMENTDETAILSEGUE = "DocDetailSegue"
let DASHBOARDSEGUE = "DashboardSegue"


//MARK: Role Enum
enum Role:Int {
    case fitter = 1
    case welder
    case shipper
    case qa
}




