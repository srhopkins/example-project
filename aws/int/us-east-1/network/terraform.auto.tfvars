cidr          = "10.10.0.0/21"
azs           = ["us-east-1a", "us-east-1b"]

public_subnets = {
    mask = 26
    init = 2
}

private_subnets = {
    mask = 24
    init = 2
}
