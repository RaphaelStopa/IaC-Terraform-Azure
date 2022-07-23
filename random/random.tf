terraform {
    required_providers{
        random = {
            source = "hashicorp/random"
        }
        # note that you can have more than one provider
        archive = {
            source = "hashicorp/random"
        }
    }
}

resource "random_string" "random" {
    length =  8
}

# How variables are made. Example
variable "tamanho" {
    type = string
    default = "S1"
    description = random_string.random
}

# The following example shows how to generate a random priority
# between 1 and 50000 for a aws_alb_listener_rule resource:

resource "random_integer" "priority" {
    min = 1
    max = 50000
    keepers = {
        # Generate a new integer each time we switch to a new listener ARN
        listener_arn = var.listener_arn
    }
}

resource "aws_alb_listener_rule" "main" {
    listener_arn = random_integer.priority.keepers.listener_arn
    priority     = random_integer.priority.result

    action {
        type             = "forward"
        target_group_arn = var.target_group_arn
    }
    # ... (other aws_alb_listener_rule arguments) ...
}