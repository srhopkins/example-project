## Subnet Calculator
Takes a VPC cidr block and outputs cidrs only for public and private subnet blocks. The module creates no resources only outputs.

| Variable       | Description                         | Type   | Default                 |
|----------------|-------------------------------------|--------|-------------------------| 
| cidr_block      | VPC cidr where subnets will reside | string | none                    |
| public_subnets  | Desired count and mask for public  | map    | `init = 2`, `mask = 27` |
| private_subnets | Desired count and mask for private | map    | `init = 2`, `mask = 25` |

Uses base cidr block to partition private subnet from the beginning of the network segment and partitions the public subnet backwards from the end of the segment going off the assumption that smaller public subnets are desired.

```
$ terraform apply -var 'cidr_block=10.155.196.0/23' \
	-var 'public_subnets.init=2' \
	-var 'public_subnets.mask=27' \
	-var 'private_subnets.init=2' \
	-var 'private_subnets.mask=25'

...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

cidr_block = 10.155.196.0/23
cidr_block_mask = 23
private_cidrs = [
    10.155.196.0/25,
    10.155.196.128/25
]
public_cidrs = [
    10.155.197.224/27,
    10.155.197.192/27
]
```

The above looks like

```
<------------------------------------------------------------ 512 ------------------------------------------------------------>
<--------------------- private -------------------------------> <------------------ unused -------------------> <--- public -->
<------------ 128 ------------> <------------ 128 ------------> <-------------------- 192 --------------------> <-32 -> <-32 ->     
```


