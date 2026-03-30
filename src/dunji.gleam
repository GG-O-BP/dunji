//// 카카오 우편번호 서비스(Kakao Postcode)의 Lustre 전용 Gleam 래퍼.
////
//// Lustre TEA 패턴에 맞춰 `Effect(msg)`를 반환하는 API를 제공한다.
////
//// ## 빠른 시작
////
//// ```gleam
//// import dunji
//// import dunji/address.{type Address}
////
//// type Msg {
////   UserClickedSearch
////   GotAddress(Address)
//// }
////
//// fn update(model, msg) {
////   case msg {
////     UserClickedSearch ->
////       #(model, dunji.open_default(on_complete: GotAddress))
////     GotAddress(addr) ->
////       #(Model(..model, address: Some(addr)), effect.none())
////   }
//// }
//// ```

import dunji/address.{type Address}
import dunji/options.{type Options}
import gleam/option.{type Option, None}
import lustre/effect.{type Effect}

/// 팝업 닫힘 상태.
pub type CloseState {
  /// 사용자가 닫기 버튼을 클릭.
  ForceClose
  /// 사용자가 주소를 선택하여 닫힘.
  CompleteClose
}

/// embed 모드에서 크기 변경 정보.
pub type Size {
  Size(width: Int, height: Int)
}

/// 검색 이벤트 정보.
pub type SearchData {
  SearchData(query: String, count: Int)
}

/// 카카오 우편번호 서비스를 팝업으로 연다.
///
/// ## 예시
///
/// ```gleam
/// // 기본 사용
/// dunji.open(
///   options: options.default(),
///   on_complete: GotAddress,
///   on_close: None,
///   on_search: None,
/// )
///
/// // 콜백 추가
/// dunji.open(
///   options: options.default() |> options.animation(True),
///   on_complete: GotAddress,
///   on_close: Some(GotClose),
///   on_search: None,
/// )
/// ```
pub fn open(
  options options: Options,
  on_complete on_complete: fn(Address) -> msg,
  on_close on_close: Option(fn(CloseState) -> msg),
  on_search on_search: Option(fn(SearchData) -> msg),
) -> Effect(msg) {
  effect.from(fn(dispatch) {
    let wrapped_complete = fn(addr: Address) { dispatch(on_complete(addr)) }

    let wrapped_close =
      option.map(on_close, fn(handler) {
        fn(state: String) {
          let close_state = case state {
            "FORCE_CLOSE" -> ForceClose
            _ -> CompleteClose
          }
          dispatch(handler(close_state))
        }
      })

    let wrapped_search =
      option.map(on_search, fn(handler) {
        fn(q: String, count: Int) {
          dispatch(handler(SearchData(query: q, count: count)))
        }
      })

    do_open(options, wrapped_complete, wrapped_close, wrapped_search)
  })
}

/// 카카오 우편번호 서비스를 DOM 요소에 임베드한다.
///
/// `selector`는 대상 요소의 CSS 선택자 (예: `"#address-search"`).
///
/// ## 예시
///
/// ```gleam
/// dunji.embed(
///   selector: "#postcode-container",
///   options: options.default(),
///   on_complete: GotAddress,
///   on_close: None,
///   on_resize: None,
///   on_search: None,
/// )
/// ```
pub fn embed(
  selector selector: String,
  options options: Options,
  on_complete on_complete: fn(Address) -> msg,
  on_close on_close: Option(fn(CloseState) -> msg),
  on_resize on_resize: Option(fn(Size) -> msg),
  on_search on_search: Option(fn(SearchData) -> msg),
) -> Effect(msg) {
  effect.from(fn(dispatch) {
    let wrapped_complete = fn(addr: Address) { dispatch(on_complete(addr)) }

    let wrapped_close =
      option.map(on_close, fn(handler) {
        fn(state: String) {
          let close_state = case state {
            "FORCE_CLOSE" -> ForceClose
            _ -> CompleteClose
          }
          dispatch(handler(close_state))
        }
      })

    let wrapped_resize =
      option.map(on_resize, fn(handler) {
        fn(w: Int, h: Int) { dispatch(handler(Size(width: w, height: h))) }
      })

    let wrapped_search =
      option.map(on_search, fn(handler) {
        fn(q: String, count: Int) {
          dispatch(handler(SearchData(query: q, count: count)))
        }
      })

    do_embed(
      selector,
      options,
      wrapped_complete,
      wrapped_close,
      wrapped_resize,
      wrapped_search,
    )
  })
}

/// 기본 옵션으로 팝업을 여는 편의 함수.
///
/// ```gleam
/// dunji.open_default(on_complete: GotAddress)
/// ```
pub fn open_default(on_complete on_complete: fn(Address) -> msg) -> Effect(msg) {
  open(
    options: options.default(),
    on_complete: on_complete,
    on_close: None,
    on_search: None,
  )
}

/// 기본 옵션으로 DOM 요소에 임베드하는 편의 함수.
///
/// ```gleam
/// dunji.embed_default(selector: "#container", on_complete: GotAddress)
/// ```
pub fn embed_default(
  selector selector: String,
  on_complete on_complete: fn(Address) -> msg,
) -> Effect(msg) {
  embed(
    selector: selector,
    options: options.default(),
    on_complete: on_complete,
    on_close: None,
    on_resize: None,
    on_search: None,
  )
}

// --- FFI declarations ---

@external(javascript, "./dunji_ffi.mjs", "do_open")
fn do_open(
  options: Options,
  on_complete: fn(Address) -> Nil,
  on_close: Option(fn(String) -> Nil),
  on_search: Option(fn(String, Int) -> Nil),
) -> Nil

@external(javascript, "./dunji_ffi.mjs", "do_embed")
fn do_embed(
  selector: String,
  options: Options,
  on_complete: fn(Address) -> Nil,
  on_close: Option(fn(String) -> Nil),
  on_resize: Option(fn(Int, Int) -> Nil),
  on_search: Option(fn(String, Int) -> Nil),
) -> Nil
