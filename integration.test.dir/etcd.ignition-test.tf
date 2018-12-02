
module etcd-ignition-config-1
{
    source         = ".."
}

module etcd-ignition-config-2
{
    source        = ".."
    in_node_count = 6
}

output etcd_ignition_config_1
{
    value = "${ module.etcd-ignition-config-1.out_ignition_config }"
}

output etcd_ignition_config_2
{
    value = "${ module.etcd-ignition-config-2.out_ignition_config }"
}
