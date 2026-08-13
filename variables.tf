variable "guardduty_filters" {
  description = <<EOT
Map of guardduty_filters, attributes below
Required:
    - action
    - detector_id
    - name
    - rank
    - finding_criteria (block):
        - criterion (required, block):
            - equals (optional)
            - field (required)
            - greater_than (optional)
            - greater_than_or_equal (optional)
            - less_than (optional)
            - less_than_or_equal (optional)
            - matches (optional)
            - not_equals (optional)
            - not_matches (optional)
Optional:
    - description
    - region
    - tags
    - tags_all
EOT

  type = map(object({
    action      = string
    detector_id = string
    name        = string
    rank        = number
    description = optional(string)
    region      = optional(string)
    tags        = optional(map(string))
    tags_all    = optional(map(string))
    finding_criteria = object({
      criterion = list(object({
        equals                = optional(list(string))
        field                 = string
        greater_than          = optional(string)
        greater_than_or_equal = optional(string)
        less_than             = optional(string)
        less_than_or_equal    = optional(string)
        matches               = optional(list(string))
        not_equals            = optional(list(string))
        not_matches           = optional(list(string))
      }))
    })
  }))
  validation {
    condition = alltrue([
      for k, v in var.guardduty_filters : (
        length(v.finding_criteria.criterion) >= 1
      )
    ])
    error_message = "Each criterion list must contain at least 1 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.guardduty_filters : (
        alltrue([for item in v.finding_criteria.criterion : (item.matches == null || (alltrue([for x in item.matches : length(x) >= 1 && length(x) <= 512])))])
      )
    ])
    error_message = "must be between 1 and 512 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.guardduty_filters : (
        alltrue([for item in v.finding_criteria.criterion : (item.not_matches == null || (alltrue([for x in item.not_matches : length(x) >= 1 && length(x) <= 512])))])
      )
    ])
    error_message = "must be between 1 and 512 characters"
  }
  # Note: 7 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

