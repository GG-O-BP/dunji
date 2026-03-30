import dunji/theme.{type Theme}
import gleam/option.{type Option, None, Some}

/// 크기 단위: 픽셀 또는 퍼센트.
///
/// 레이어/embed 모드에서는 퍼센트 사용 가능.
pub type Dimension {
  /// 픽셀 단위 (예: `Px(500)`).
  Px(Int)
  /// 퍼센트 단위 (예: `Percent(100)` → `"100%"`). 레이어/embed 모드 전용.
  Percent(Int)
}

/// 카카오 우편번호 서비스 생성자 옵션.
///
/// 콜백 함수는 포함하지 않으며, `dunji.open()`이나 `dunji.embed()`의
/// 인자로 별도 전달한다.
///
/// `default()`로 생성한 뒤 builder 함수로 원하는 값만 설정한다.
///
/// ## 예시
///
/// ```gleam
/// let opts =
///   options.default()
///   |> options.width(400)
///   |> options.height(500)
///   |> options.animation(True)
///   |> options.theme(my_theme)
/// ```
pub type Options {
  Options(
    // -- 크기 --
    /// 팝업/레이어 고정 너비. 기본값: 500px. 레이어 모드에서 퍼센트 가능.
    width: Option(Dimension),
    /// 팝업/레이어 고정 높이. 기본값: 500px, 최소: 400px. 레이어 모드에서 퍼센트 가능.
    height: Option(Dimension),
    /// 최소 너비 (px). 기본값: 300, 범위: 0-300.
    min_width: Option(Int),
    // -- 동작 --
    /// 애니메이션 효과 사용 여부. 기본값: False.
    animation: Option(Bool),
    /// 실행 시 검색 입력창 자동 포커스 (PC만). 기본값: True.
    focus_input: Option(Bool),
    /// 도로명 1:N 매핑 시 "선택 안함" 표시. 기본값: True.
    auto_mapping_road: Option(Bool),
    /// 지번 1:N 매핑 시 "선택 안함" 표시. 기본값: True.
    auto_mapping_jibun: Option(Bool),
    /// 시/도 약칭 사용 (서울특별시 → 서울). 기본값: True.
    shorthand: Option(Bool),
    /// form submit 사용 여부. 기본값: True.
    submit_mode: Option(Bool),
    /// 하단 배너 링크 사용 여부. 기본값: True.
    use_banner_link: Option(Bool),
    // -- UI --
    /// 지도 버튼 숨기기. 기본값: False.
    hide_map_btn: Option(Bool),
    /// 영문보기 버튼 숨기기. 기본값: False.
    hide_eng_btn: Option(Bool),
    /// 한글/영문 주소 동시 표시. 기본값: False.
    always_show_eng_addr: Option(Bool),
    /// 검색 결과가 지정 페이지 이상일 때 가이드 강조 (3-20). 기본값: 0 (비활성).
    please_read_guide: Option(Int),
    /// 가이드 강조 지속 시간 (초, 0.1-60). 기본값: 1.5.
    please_read_guide_timer: Option(Float),
    /// 검색 드롭다운 최대 추천 항목 수 (1-10). 기본값: 10.
    max_suggest_items: Option(Int),
    /// 행정동이 법정동과 다를 때 행정동 표시. 기본값: False.
    show_more_h_name: Option(Bool),
    // -- 테마 --
    /// 색상 테마 설정.
    theme: Option(Theme),
    // -- 메서드 파라미터 (open/embed 공통) --
    /// 초기 검색어.
    query: Option(String),
    /// 주소 선택 후 자동 닫기. 기본값: True.
    auto_close: Option(Bool),
    // -- open() 전용 파라미터 --
    /// 팝업 X 좌표 (px). open() 전용.
    left: Option(Int),
    /// 팝업 Y 좌표 (px). open() 전용.
    top: Option(Int),
    /// 팝업 창 제목. open() 전용.
    popup_title: Option(String),
    /// 중복 팝업 방지 키. 같은 키로 여러 번 open 시 하나만 열림. open() 전용.
    popup_key: Option(String),
  )
}

/// 기본 옵션 (모든 값 미설정 — 카카오 기본값 사용).
pub fn default() -> Options {
  Options(
    width: None,
    height: None,
    min_width: None,
    animation: None,
    focus_input: None,
    auto_mapping_road: None,
    auto_mapping_jibun: None,
    shorthand: None,
    submit_mode: None,
    use_banner_link: None,
    hide_map_btn: None,
    hide_eng_btn: None,
    always_show_eng_addr: None,
    please_read_guide: None,
    please_read_guide_timer: None,
    max_suggest_items: None,
    show_more_h_name: None,
    theme: None,
    query: None,
    auto_close: None,
    left: None,
    top: None,
    popup_title: None,
    popup_key: None,
  )
}

/// 팝업/레이어 고정 너비 설정 (px).
pub fn width(options: Options, value: Int) -> Options {
  Options(..options, width: Some(Px(value)))
}

/// 팝업/레이어 고정 너비를 퍼센트로 설정. 레이어/embed 모드 전용.
pub fn width_percent(options: Options, value: Int) -> Options {
  Options(..options, width: Some(Percent(value)))
}

/// 팝업/레이어 고정 높이 설정 (px, 최소 400).
pub fn height(options: Options, value: Int) -> Options {
  Options(..options, height: Some(Px(value)))
}

/// 팝업/레이어 고정 높이를 퍼센트로 설정. 레이어/embed 모드 전용.
pub fn height_percent(options: Options, value: Int) -> Options {
  Options(..options, height: Some(Percent(value)))
}

/// 최소 너비 설정 (px, 0-300).
pub fn min_width(options: Options, value: Int) -> Options {
  Options(..options, min_width: Some(value))
}

/// 애니메이션 효과 사용 여부 설정.
pub fn animation(options: Options, value: Bool) -> Options {
  Options(..options, animation: Some(value))
}

/// 실행 시 검색 입력창 자동 포커스 설정 (PC만).
pub fn focus_input(options: Options, value: Bool) -> Options {
  Options(..options, focus_input: Some(value))
}

/// 도로명 1:N 매핑 시 "선택 안함" 표시 설정.
pub fn auto_mapping_road(options: Options, value: Bool) -> Options {
  Options(..options, auto_mapping_road: Some(value))
}

/// 지번 1:N 매핑 시 "선택 안함" 표시 설정.
pub fn auto_mapping_jibun(options: Options, value: Bool) -> Options {
  Options(..options, auto_mapping_jibun: Some(value))
}

/// 도로명/지번 1:N 매핑 "선택 안함" 표시를 동시에 설정하는 축약.
pub fn auto_mapping(options: Options, value: Bool) -> Options {
  Options(
    ..options,
    auto_mapping_road: Some(value),
    auto_mapping_jibun: Some(value),
  )
}

/// 시/도 약칭 사용 설정.
pub fn shorthand(options: Options, value: Bool) -> Options {
  Options(..options, shorthand: Some(value))
}

/// form submit 사용 여부 설정.
pub fn submit_mode(options: Options, value: Bool) -> Options {
  Options(..options, submit_mode: Some(value))
}

/// 하단 배너 링크 사용 여부 설정.
pub fn use_banner_link(options: Options, value: Bool) -> Options {
  Options(..options, use_banner_link: Some(value))
}

/// 지도 버튼 숨기기 설정.
pub fn hide_map_btn(options: Options, value: Bool) -> Options {
  Options(..options, hide_map_btn: Some(value))
}

/// 영문보기 버튼 숨기기 설정.
pub fn hide_eng_btn(options: Options, value: Bool) -> Options {
  Options(..options, hide_eng_btn: Some(value))
}

/// 한글/영문 주소 동시 표시 설정.
pub fn always_show_eng_addr(options: Options, value: Bool) -> Options {
  Options(..options, always_show_eng_addr: Some(value))
}

/// 검색 결과 가이드 강조 페이지 수 설정 (3-20, 0은 비활성).
pub fn please_read_guide(options: Options, value: Int) -> Options {
  Options(..options, please_read_guide: Some(value))
}

/// 가이드 강조 지속 시간 설정 (초, 0.1-60).
pub fn please_read_guide_timer(options: Options, value: Float) -> Options {
  Options(..options, please_read_guide_timer: Some(value))
}

/// 검색 드롭다운 최대 추천 항목 수 설정 (1-10).
pub fn max_suggest_items(options: Options, value: Int) -> Options {
  Options(..options, max_suggest_items: Some(value))
}

/// 행정동이 법정동과 다를 때 행정동 표시 설정.
pub fn show_more_h_name(options: Options, value: Bool) -> Options {
  Options(..options, show_more_h_name: Some(value))
}

/// 색상 테마 설정.
pub fn theme(options: Options, value: Theme) -> Options {
  Options(..options, theme: Some(value))
}

/// 초기 검색어 설정.
pub fn query(options: Options, value: String) -> Options {
  Options(..options, query: Some(value))
}

/// 주소 선택 후 자동 닫기 설정.
pub fn auto_close(options: Options, value: Bool) -> Options {
  Options(..options, auto_close: Some(value))
}

/// 팝업 X 좌표 설정 (px). open() 전용.
pub fn left(options: Options, value: Int) -> Options {
  Options(..options, left: Some(value))
}

/// 팝업 Y 좌표 설정 (px). open() 전용.
pub fn top(options: Options, value: Int) -> Options {
  Options(..options, top: Some(value))
}

/// 팝업 창 제목 설정. open() 전용.
pub fn popup_title(options: Options, value: String) -> Options {
  Options(..options, popup_title: Some(value))
}

/// 중복 팝업 방지 키 설정. open() 전용.
pub fn popup_key(options: Options, value: String) -> Options {
  Options(..options, popup_key: Some(value))
}
