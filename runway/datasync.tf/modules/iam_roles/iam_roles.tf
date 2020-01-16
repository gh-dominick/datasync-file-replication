resource "aws_iam_role" "datasync-task-execution-role" {
  name = "${var.customer}-${var.env}-datasync-task-execution-role"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": [ "ssm.amazonaws.com" ] },
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "datasync-task-execution-pass-role-policy" {
  name   = "${var.customer}-${var.env}-datasync-task-execution-pass-role-policy"
  policy = <<EOF
{
  "Version": "2017-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [ "iam:PassRole" ],
      "Resource": [ "*" ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-task-execution-pass-role-policy" {
  role = "${aws_iam_role.datasync-task-exectution-role.name}"
  policy_arn = "${aws_iam_policy.datasync-task-execution-pass-role-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-ssm-maintenance-window-role-policy" {
  role = "${aws_iam_role.datasync-task-exectution-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}

resource "aws_iam_role" "datasync-agent-role" {
  name = "${var.customer}-${var.env}-datasync-agent-role"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": [ "ec2.amazonaws.com" ] },
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "datasync-agent-policy" {
  name = "${var.customer}-${var.env}-datasync-agent-policy"
  policy = <<EOF
{
  "Version": "2017-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [ "datasync:*" ],
      "Resource": [ "*" ]
    },
    {
      "Effect": "Allow",
      "Action": [ "ec2:*" ],
      "Resource": [ "*" ]
    },
    {
      "Effect": "Allow",
      "Action": [ "elasticfilesystem:Describe*" ],
      "Resource": [ "*" ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-datasync-agent-policy" {
  role = "${aws_iam_role.datasync-agent-role.name}"
  policy_arn = "${aws_iam_role.datasync-agent-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-ec2-role-for-ssm" {
  role = "${aws_iam_role.datasync-agent-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "datasync-agent-instance-profile" {
  name = "${var.customer}-${var.env}-datasync-agent-instance-profile"
  path = "/"
  role = "${aws_iam_role.datasync-agent-role.name}"
}
