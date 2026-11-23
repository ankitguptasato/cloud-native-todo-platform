resource "grafana_rule_group" "rule_group_e66c330392c57e85" {
  org_id           = 1
  name             = "first alert"
  folder_uid       = "fk62sz"
  interval_seconds = 300

  rule {
    name      = "Node Count"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum(kube_node_status_condition{condition=\\\"Ready\\\",status=\\\"true\\\"}) < 2\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id     = "C"
      query_type = "expression"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    is_paused      = false

    notification_settings {
      contact_point = "Ankit"
    }
  }
}
