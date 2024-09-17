{% set file_name = name |  snake_case -%}
{% set module_name = file_name | pascal_case -%}
to: tests/requests/{{ file_name }}.rs
skip_exists: true
message: "Tests for controller `{{module_name}}` was added successfully. Run `cargo run test`."
injections:
- into: tests/requests/mod.rs
  append: true
  content: "pub mod {{ file_name }};"
---
use {{pkg_name}}::app::App;
use loco_rs::testing;
use serial_test::serial;

{% for action in actions -%}
#[tokio::test]
#[serial]
async fn can_get_{{action}}() {
    testing::request::<App, _, _>(|request, _ctx| async move {
        let res = request.get("/{{ name | snake_case }}/{{action}}").await;
        assert_eq!(res.status_code(), 200);
    })
    .await;
}

{% endfor -%}