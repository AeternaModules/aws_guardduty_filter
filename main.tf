resource "aws_guardduty_filter" "guardduty_filters" {
  for_each = var.guardduty_filters

  action      = each.value.action
  detector_id = each.value.detector_id
  name        = each.value.name
  rank        = each.value.rank
  description = each.value.description
  region      = each.value.region
  tags        = each.value.tags
  tags_all    = each.value.tags_all

  finding_criteria {
    dynamic "criterion" {
      for_each = each.value.finding_criteria.criterion
      content {
        equals                = criterion.value.equals
        field                 = criterion.value.field
        greater_than          = criterion.value.greater_than
        greater_than_or_equal = criterion.value.greater_than_or_equal
        less_than             = criterion.value.less_than
        less_than_or_equal    = criterion.value.less_than_or_equal
        matches               = criterion.value.matches
        not_equals            = criterion.value.not_equals
        not_matches           = criterion.value.not_matches
      }
    }
  }
}

