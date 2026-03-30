import gleam/option.{type Option}

/// 주소 유형: 도로명 또는 지번.
pub type AddressType {
  /// 도로명주소 (카카오 API에서 "R").
  Road
  /// 지번주소 (카카오 API에서 "J").
  Jibun
}

/// 사용자가 검색 시 선택한 언어.
pub type LanguageType {
  /// 한국어 (카카오 API에서 "K").
  Korean
  /// 영어 (카카오 API에서 "E").
  English
}

/// 카카오 우편번호 서비스 oncomplete 콜백에서 반환되는 주소 데이터.
///
/// 빈 문자열 가능 필드는 `Option(String)`으로 표현되며,
/// 해당 주소에 적용되지 않는 경우 `None`이 된다.
/// `apartment`와 `no_selected`는 카카오 "Y"/"N" 문자열에서
/// `Bool`로 변환된다.
pub type Address {
  Address(
    /// 5자리 우편번호 (신우편번호).
    zonecode: String,
    /// 기본 주소 (검색 결과 첫 줄).
    address: String,
    /// 기본 주소 영문.
    address_english: String,
    /// 기본 주소 필드의 주소 유형.
    address_type: AddressType,
    /// 사용자가 실제 선택한 주소 유형 (address_type과 다를 수 있음).
    user_selected_type: AddressType,
    /// 사용자가 입력한 검색어.
    query: String,
    // -- 도로명주소 --
    /// 도로명주소 (한글).
    road_address: String,
    /// 도로명주소 (영문).
    road_address_english: Option(String),
    /// 1:N 매핑 시 시스템 추천 도로명주소.
    auto_road_address: Option(String),
    /// 시스템 추천 도로명주소 영문.
    auto_road_address_english: Option(String),
    // -- 지번주소 --
    /// 지번주소 (한글).
    jibun_address: String,
    /// 지번주소 (영문).
    jibun_address_english: Option(String),
    /// 1:N 매핑 시 시스템 추천 지번주소.
    auto_jibun_address: Option(String),
    /// 시스템 추천 지번주소 영문.
    auto_jibun_address_english: Option(String),
    // -- 도로명 구성요소 --
    /// 도로명 (건물번호 제외).
    roadname: Option(String),
    /// 도로명 영문.
    roadname_english: Option(String),
    /// 도로명 코드 (7자리).
    roadname_code: Option(String),
    // -- 행정구역 --
    /// 시/도명 (약칭 가능).
    sido: String,
    /// 시/도명 영문.
    sido_english: String,
    /// 시/군/구명.
    sigungu: String,
    /// 시/군/구명 영문.
    sigungu_english: String,
    /// 시/군/구 코드 (5자리).
    sigungu_code: String,
    // -- 동/리 구성요소 --
    /// 법정동/리명.
    bname: Option(String),
    /// 법정동/리명 영문.
    bname_english: Option(String),
    /// 읍/면명 (동 지역은 빈 값).
    bname1: Option(String),
    /// 읍/면명 영문.
    bname1_english: Option(String),
    /// 법정동명.
    bname2: Option(String),
    /// 법정동명 영문.
    bname2_english: Option(String),
    /// 행정동명 (법정동과 다를 때만 존재).
    hname: Option(String),
    // -- 건물 정보 --
    /// 건물관리번호.
    building_code: Option(String),
    /// 건물명.
    building_name: Option(String),
    /// 공동주택 여부.
    apartment: Bool,
    /// 법정동/리 코드.
    bcode: String,
    /// 사용자가 "선택 안함"을 클릭했는지 여부.
    no_selected: Bool,
    /// 사용자가 검색 시 사용한 언어.
    user_language_type: LanguageType,
  )
}

/// 사용자가 선택한 주소 유형에 따라 적절한 주소를 반환한다.
///
/// 도로명을 선택했으면 `road_address`, 지번을 선택했으면 `jibun_address`.
pub fn selected_address(address: Address) -> String {
  case address.user_selected_type {
    Road -> address.road_address
    Jibun -> address.jibun_address
  }
}

/// 사용자가 선택한 주소 유형에 따라 영문 주소를 반환한다.
pub fn selected_address_english(address: Address) -> Option(String) {
  case address.user_selected_type {
    Road -> address.road_address_english
    Jibun -> address.jibun_address_english
  }
}
