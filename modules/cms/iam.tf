#
# IAM Permissions for Nomad client execution.
#
resource "aws_iam_role" "nomad_client" {
  name = "${local.prefix}-nomad-client"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "nomad_client" {
  name       = "${local.prefix}-nomad-client"
  roles      = ["${aws_iam_role.nomad_client.name}"]
  policy_arn = "arn:${lookup(local.arn_prefix,data.aws_region.current.name)}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "nomad_client" {
  name = "${local.prefix}-nomad-client"
  role = "${aws_iam_role.nomad_client.name}"
}
