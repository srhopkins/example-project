cidr          = "10.0.0.0/23"
azs           = ["us-east-1a", "us-east-1b"]

public_subnets = {
    mask = 28
    init = 2
}

private_subnets = {
    mask = 26
    init = 2
}
