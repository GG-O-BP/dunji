# dunji

[![Package Version](https://img.shields.io/hexpm/v/dunji)](https://hex.pm/packages/dunji)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/dunji/)

[카카오 우편번호 서비스](https://postcode.map.daum.net/guide)(Kakao Postcode)의
[Lustre](https://hexdocs.pm/lustre/) 전용 Gleam 래퍼 라이브러리.

- Lustre TEA 패턴 통합 (`Effect(msg)` 반환)
- 타입 안전한 주소 데이터 (`Address` record, 35개 필드)
- Builder 패턴 옵션/테마 설정
- 카카오 CDN 스크립트 자동 로딩
- API 키 불필요

## 설치

```sh
gleam add dunji@1
```

## 사용법

```gleam
import dunji
import dunji/address.{type Address}
import dunji/options
import dunji/theme
import gleam/option.{None, Some}
import lustre/effect

type Msg {
  UserClickedSearch
  GotAddress(Address)
}

fn update(model, msg) {
  case msg {
    // 가장 간단한 사용
    UserClickedSearch ->
      #(model, dunji.open_default(on_complete: GotAddress))

    GotAddress(addr) ->
      #(Model(..model, address: Some(addr)), effect.none())
  }
}
```

### 옵션 커스터마이징

```gleam
let my_theme =
  theme.default()
  |> theme.search_bg_color("#0B65C8")
  |> theme.query_text_color("#FFFFFF")

let opts =
  options.default()
  |> options.width(400)
  |> options.height(500)
  |> options.animation(True)
  |> options.theme(my_theme)

dunji.open(
  options: opts,
  on_complete: GotAddress,
  on_close: Some(GotClose),
  on_search: None,
)
```

### Embed 모드

```gleam
dunji.embed(
  selector: "#postcode-container",
  options: options.default()
    |> options.width_percent(100)
    |> options.height_percent(100),
  on_complete: GotAddress,
  on_close: None,
  on_resize: Some(GotResize),
  on_search: None,
)
```

## API

| 함수 | 설명 |
|------|------|
| `dunji.open_default(on_complete:)` | 기본 옵션으로 팝업 열기 |
| `dunji.open(options:, on_complete:, on_close:, on_search:)` | 전체 옵션 팝업 열기 |
| `dunji.embed_default(selector:, on_complete:)` | 기본 옵션으로 DOM 요소에 임베드 |
| `dunji.embed(selector:, options:, on_complete:, on_close:, on_resize:, on_search:)` | 전체 옵션 임베드 |

## 모듈 구조

| 모듈 | 내용 |
|------|------|
| `dunji` | 공개 API — `open`, `embed`, `CloseState`, `Size`, `SearchData` |
| `dunji/address` | `Address` record, `AddressType`, `LanguageType`, 편의 함수 |
| `dunji/options` | `Options`, `Dimension` 타입 + builder 함수 |
| `dunji/theme` | `Theme` 타입 + builder 함수 |

## 개발

```sh
gleam build --target javascript
gleam test --target javascript
gleam format --check src test
```

JavaScript 타겟 전용 라이브러리입니다.

## 라이선스

[Blue Oak Model License 1.0.0](https://blueoakcouncil.org/license/1.0.0)
