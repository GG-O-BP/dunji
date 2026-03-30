import dunji/address.{type Address, Address, English, Jibun, Korean, Road}
import dunji/options.{Percent, Px}
import dunji/theme
import gleam/option.{None, Some}
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

fn sample_address() -> Address {
  Address(
    zonecode: "06140",
    address: "서울 강남구 ��헤란로 423",
    address_english: "423, Teheran-ro, Gangnam-gu, Seoul, Korea",
    address_type: Road,
    user_selected_type: Road,
    query: "테헤���로 423",
    road_address: "서울 강남구 테헤란로 423",
    road_address_english: Some("423, Teheran-ro, Gangnam-gu, Seoul, Korea"),
    auto_road_address: None,
    auto_road_address_english: None,
    jibun_address: "서울 강남구 삼성동 157-36",
    jibun_address_english: Some(
      "157-36, Samseong-dong, Gangnam-gu, Seoul, Korea",
    ),
    auto_jibun_address: None,
    auto_jibun_address_english: None,
    roadname: Some("테헤란로"),
    roadname_english: Some("Teheran-ro"),
    roadname_code: Some("1168055"),
    sido: "서울",
    sido_english: "Seoul",
    sigungu: "강남구",
    sigungu_english: "Gangnam-gu",
    sigungu_code: "11680",
    bname: Some("삼성동"),
    bname_english: Some("Samseong-dong"),
    bname1: None,
    bname1_english: None,
    bname2: Some("삼성동"),
    bname2_english: Some("Samseong-dong"),
    hname: None,
    building_code: Some("1168010600115703600004"),
    building_name: Some("한��과학기술회관 신관"),
    apartment: False,
    bcode: "1168010600",
    no_selected: False,
    user_language_type: Korean,
  )
}

pub fn selected_address_road_test() {
  let addr = sample_address()
  assert addr.user_selected_type == Road
  assert address.selected_address(addr) == "서울 강남구 테헤란로 423"
  assert address.selected_address_english(addr)
    == Some("423, Teheran-ro, Gangnam-gu, Seoul, Korea")
}

pub fn selected_address_jibun_test() {
  let addr = Address(..sample_address(), user_selected_type: Jibun)
  assert address.selected_address(addr) == "서울 강남구 삼성동 157-36"
  assert address.selected_address_english(addr)
    == Some("157-36, Samseong-dong, Gangnam-gu, Seoul, Korea")
}

pub fn address_type_test() {
  let addr = sample_address()
  assert addr.address_type == Road
  assert addr.apartment == False
  assert addr.no_selected == False
  assert addr.user_language_type == Korean
}

pub fn address_english_language_test() {
  let addr = Address(..sample_address(), user_language_type: English)
  assert addr.user_language_type == English
}

pub fn options_default_test() {
  let opts = options.default()
  assert opts.width == None
  assert opts.height == None
  assert opts.animation == None
  assert opts.theme == None
  assert opts.query == None
  assert opts.auto_close == None
  assert opts.left == None
  assert opts.top == None
  assert opts.popup_title == None
  assert opts.popup_key == None
}

pub fn options_builder_test() {
  let opts =
    options.default()
    |> options.width(400)
    |> options.height(600)
    |> options.animation(True)
    |> options.query("서울 강남구")
    |> options.auto_close(False)
  assert opts.width == Some(Px(400))
  assert opts.height == Some(Px(600))
  assert opts.animation == Some(True)
  assert opts.query == Some("서울 강남구")
  assert opts.auto_close == Some(False)
}

pub fn options_all_builders_test() {
  let opts =
    options.default()
    |> options.min_width(200)
    |> options.focus_input(False)
    |> options.auto_mapping_road(False)
    |> options.auto_mapping_jibun(False)
    |> options.shorthand(False)
    |> options.submit_mode(False)
    |> options.use_banner_link(False)
    |> options.hide_map_btn(True)
    |> options.hide_eng_btn(True)
    |> options.always_show_eng_addr(True)
    |> options.please_read_guide(5)
    |> options.please_read_guide_timer(3.0)
    |> options.max_suggest_items(5)
    |> options.show_more_h_name(True)
  assert opts.min_width == Some(200)
  assert opts.focus_input == Some(False)
  assert opts.hide_map_btn == Some(True)
  assert opts.please_read_guide == Some(5)
  assert opts.please_read_guide_timer == Some(3.0)
  assert opts.max_suggest_items == Some(5)
  assert opts.show_more_h_name == Some(True)
}

pub fn theme_default_test() {
  let t = theme.default()
  assert t.bg_color == None
  assert t.search_bg_color == None
  assert t.text_color == None
  assert t.outline_color == None
}

pub fn theme_builder_test() {
  let t =
    theme.default()
    |> theme.bg_color("#F0F0F0")
    |> theme.search_bg_color("#0B65C8")
    |> theme.query_text_color("#FFFFFF")
    |> theme.emph_text_color("#FF5733")
  assert t.bg_color == Some("#F0F0F0")
  assert t.search_bg_color == Some("#0B65C8")
  assert t.query_text_color == Some("#FFFFFF")
  assert t.emph_text_color == Some("#FF5733")
  assert t.content_bg_color == None
}

pub fn options_dimension_percent_test() {
  let opts =
    options.default()
    |> options.width_percent(100)
    |> options.height_percent(100)
  assert opts.width == Some(Percent(100))
  assert opts.height == Some(Percent(100))
}

pub fn options_auto_mapping_test() {
  let opts =
    options.default()
    |> options.auto_mapping(False)
  assert opts.auto_mapping_road == Some(False)
  assert opts.auto_mapping_jibun == Some(False)
}

pub fn options_open_params_test() {
  let opts =
    options.default()
    |> options.left(100)
    |> options.top(200)
    |> options.popup_title("주소 검색")
    |> options.popup_key("addr1")
  assert opts.left == Some(100)
  assert opts.top == Some(200)
  assert opts.popup_title == Some("주소 검색")
  assert opts.popup_key == Some("addr1")
}

pub fn options_with_theme_test() {
  let t =
    theme.default()
    |> theme.bg_color("#FFFFFF")
  let opts =
    options.default()
    |> options.theme(t)
  assert opts.theme == Some(t)
}

pub fn address_option_fields_test() {
  let addr =
    Address(
      ..sample_address(),
      road_address_english: None,
      building_name: None,
      hname: Some("역삼1동"),
    )
  assert addr.road_address_english == None
  assert addr.building_name == None
  assert addr.hname == Some("역삼1동")
}
