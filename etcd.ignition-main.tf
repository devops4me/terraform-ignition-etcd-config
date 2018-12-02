
/*
 | --
 | -- Visit the terraform ignition user manual at the url below to
 | -- understand how ignition is used as the de-factor cloud-init
 | -- starter for a cluster of CoreOS machines.
 | --
 | --  https://www.terraform.io/docs/providers/ignition/index.html
 | --
*/
data ignition_config etcd3
{
    systemd =
    [
        "${data.ignition_systemd_unit.etcd3.id}",
    ]
}


/*
 | --
 | -- This slice of the ignition configuration deals with the
 | -- systemd service. Once rendered it is then placed alongside
 | -- the other ignition configuration blocks in ignition_config
 | --
*/
data ignition_systemd_unit etcd3
{
    name = "etcd-member.service"
    enabled = "true"
    dropin
    {
        name    = "20-clct-etcd-member.conf"
        content = "${ data.template_file.service.rendered }"
    }
}


/*
 | --
 | -- This is the systemd unit file that ignition will run
 | -- in order to create the etcd 3 key-value store.
 | --
 | -- Terraform has to inject just one value which is the
 | -- etcd discovery url that the python script returns.
 | --
*/
data template_file service
{
    template = "${ file( "${path.module}/etcd-systemd-unit.service" ) }"

    vars
    {
        file_discovery_url = "${ data.external.url.result[ "etcd_discovery_url" ] }"
    }
}


/*
 | --
 | -- Run a bash script which only contains a curl command to retrieve
 | -- the etcd discovery url from the service offered by CoreOS.
 | -- This is how to retrieve the URL from any command line.
 | --
 | --     $ curl https://discovery.etcd.io/new?size=3
 | --
*/
data external url
{
    program = [ "python", "${path.module}/etcd-discovery-url.py", "${ var.in_node_count }" ]
}
