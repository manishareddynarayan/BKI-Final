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


//MARK: API endpoints

let USER_SIGNUP = "users/sign_up"
let USER_SIGNIN = "users/sign_in"
let SEND_INVITATION = "users/"
let HOUSEKEEPING_DOCUMENTS = "user_documents/"
let SEND_OPT = "users/forgot_password"
let UPDATE_PASSWORD = "users/reset_password"
let SIGNOUT = "users/sign_out"
let USERS = "users/"
let TASKS = "tasks/"
let CHANGEPASSWORD = "users/change_password"
let COMMENTS = "/comments"
let USERS_DASHBOARD = "users/dashboard"



//MARK: Enums
enum TaskStatus:Int {
    case notStarted = 0
    case blocked
    case completed
    case inProgress
    case noStatus
    case paused
    case rejected
    case pending
}

enum RecurrenceType:Int  {
    case daily = 0
    case weekly
    case monthly
}

