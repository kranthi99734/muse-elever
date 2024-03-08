data "aws_iam_user" "test" {
  user_name = "terraform-user"
}

resource"aws_iam_access_key" "test" {
  user = data.aws_iam_user.test.user_name
}


resource "aws_secretsmanager_secret" "test" {
  name = "muse-elever-manager"
  description = "My credentials"
}

resource "aws_secretsmanager_secret_version" "test" {
  secret_id     = "${aws_secretsmanager_secret.test.id}"
  secret_string = jsonencode({"AccessKey" = aws_iam_access_key.test.id, "SecretAccessKey" = aws_iam_access_key.test.secret})
}





















