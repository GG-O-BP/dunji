import gleam/option.{type Option, None, Some}

/// 카카오 우편번호 서비스 UI 색상 커스터마이징 설정.
///
/// `default()`로 생성한 뒤 builder 함수로 원하는 색상만 설정한다.
///
/// ## 예시
///
/// ```gleam
/// let my_theme =
///   theme.default()
///   |> theme.search_bg_color("#0B65C8")
///   |> theme.query_text_color("#FFFFFF")
/// ```
pub type Theme {
  Theme(
    /// 전체 배경색.
    bg_color: Option(String),
    /// 검색창 배경색.
    search_bg_color: Option(String),
    /// 본문 영역 배경색.
    content_bg_color: Option(String),
    /// 페이지 배경색.
    page_bg_color: Option(String),
    /// 기본 글자색.
    text_color: Option(String),
    /// 검색창 글자색.
    query_text_color: Option(String),
    /// 우편번호 글자색.
    postcode_text_color: Option(String),
    /// 강조 글자색.
    emph_text_color: Option(String),
    /// 테두리 색상.
    outline_color: Option(String),
  )
}

/// 기본 테마 (모든 색상 미설정 — 카카오 기본값 사용).
pub fn default() -> Theme {
  Theme(
    bg_color: None,
    search_bg_color: None,
    content_bg_color: None,
    page_bg_color: None,
    text_color: None,
    query_text_color: None,
    postcode_text_color: None,
    emph_text_color: None,
    outline_color: None,
  )
}

/// 전체 배경색 설정.
pub fn bg_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, bg_color: Some(color))
}

/// 검색창 배경색 설정.
pub fn search_bg_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, search_bg_color: Some(color))
}

/// 본문 영역 배경색 설정.
pub fn content_bg_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, content_bg_color: Some(color))
}

/// 페이지 배경색 설정.
pub fn page_bg_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, page_bg_color: Some(color))
}

/// 기본 글자색 설정.
pub fn text_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, text_color: Some(color))
}

/// 검색창 글자색 설정.
pub fn query_text_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, query_text_color: Some(color))
}

/// 우편번호 글자색 설정.
pub fn postcode_text_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, postcode_text_color: Some(color))
}

/// 강조 글자색 설정.
pub fn emph_text_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, emph_text_color: Some(color))
}

/// 테두리 색상 설정.
pub fn outline_color(theme: Theme, color: String) -> Theme {
  Theme(..theme, outline_color: Some(color))
}
