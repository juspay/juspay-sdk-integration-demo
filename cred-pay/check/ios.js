guard let url = URL(string: "credpay://checkout") else {
return false
}

return UIApplication.shared.canOpenURL(url)