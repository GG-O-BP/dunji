import { Some, None } from "../gleam_stdlib/gleam/option.mjs";
import {
  Address,
  Road,
  Jibun,
  Korean,
  English,
} from "./dunji/address.mjs";
import { Px } from "./dunji/options.mjs";

const SCRIPT_URL =
  "//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js";

let scriptPromise = null;

function ensureScript() {
  if (scriptPromise) return scriptPromise;
  scriptPromise = new Promise((resolve, reject) => {
    if (typeof daum !== "undefined" && daum.Postcode) {
      resolve();
      return;
    }
    const script = document.createElement("script");
    script.src = SCRIPT_URL;
    script.onload = resolve;
    script.onerror = reject;
    document.head.appendChild(script);
  });
  return scriptPromise;
}

// --- Gleam Option helpers ---

function fromOpt(opt) {
  return opt instanceof Some ? opt[0] : undefined;
}

function setIf(obj, key, opt) {
  if (opt instanceof Some) obj[key] = opt[0];
}

// --- Type conversions: Gleam -> JS ---

function themeToJs(theme) {
  const out = {};
  setIf(out, "bgColor", theme.bg_color);
  setIf(out, "searchBgColor", theme.search_bg_color);
  setIf(out, "contentBgColor", theme.content_bg_color);
  setIf(out, "pageBgColor", theme.page_bg_color);
  setIf(out, "textColor", theme.text_color);
  setIf(out, "queryTextColor", theme.query_text_color);
  setIf(out, "postcodeTextColor", theme.postcode_text_color);
  setIf(out, "emphTextColor", theme.emph_text_color);
  setIf(out, "outlineColor", theme.outline_color);
  return out;
}

function setDimension(obj, key, opt) {
  if (opt instanceof Some) {
    const dim = opt[0];
    obj[key] = dim instanceof Px ? dim[0] : dim[0] + "%";
  }
}

function optionsToJs(opts) {
  const out = {};
  setDimension(out, "width", opts.width);
  setDimension(out, "height", opts.height);
  setIf(out, "minWidth", opts.min_width);
  setIf(out, "animation", opts.animation);
  setIf(out, "focusInput", opts.focus_input);
  setIf(out, "autoMappingRoad", opts.auto_mapping_road);
  setIf(out, "autoMappingJibun", opts.auto_mapping_jibun);
  setIf(out, "shorthand", opts.shorthand);
  setIf(out, "submitMode", opts.submit_mode);
  setIf(out, "useBannerLink", opts.use_banner_link);
  setIf(out, "hideMapBtn", opts.hide_map_btn);
  setIf(out, "hideEngBtn", opts.hide_eng_btn);
  setIf(out, "alwaysShowEngAddr", opts.always_show_eng_addr);
  setIf(out, "pleaseReadGuide", opts.please_read_guide);
  setIf(out, "pleaseReadGuideTimer", opts.please_read_guide_timer);
  setIf(out, "maxSuggestItems", opts.max_suggest_items);
  setIf(out, "showMoreHName", opts.show_more_h_name);
  if (opts.theme instanceof Some) {
    out.theme = themeToJs(opts.theme[0]);
  }
  return out;
}

// --- Type conversions: JS -> Gleam ---

function optStr(s) {
  return s === "" || s == null ? new None() : new Some(s);
}

function convertAddress(data) {
  return new Address(
    data.zonecode,
    data.address,
    data.addressEnglish,
    data.addressType === "R" ? new Road() : new Jibun(),
    data.userSelectedType === "R" ? new Road() : new Jibun(),
    data.query,
    data.roadAddress,
    optStr(data.roadAddressEnglish),
    optStr(data.autoRoadAddress),
    optStr(data.autoRoadAddressEnglish),
    data.jibunAddress,
    optStr(data.jibunAddressEnglish),
    optStr(data.autoJibunAddress),
    optStr(data.autoJibunAddressEnglish),
    optStr(data.roadname),
    optStr(data.roadnameEnglish),
    optStr(data.roadnameCode),
    data.sido,
    data.sidoEnglish,
    data.sigungu,
    data.sigunguEnglish,
    data.sigunguCode,
    optStr(data.bname),
    optStr(data.bnameEnglish),
    optStr(data.bname1),
    optStr(data.bname1English),
    optStr(data.bname2),
    optStr(data.bname2English),
    optStr(data.hname),
    optStr(data.buildingCode),
    optStr(data.buildingName),
    data.apartment === "Y",
    data.bcode,
    data.noSelected === "Y",
    data.userLanguageType === "K" ? new Korean() : new English(),
  );
}

// --- Kakao Postcode API ---

export function do_open(options, onComplete, onClose, onSearch) {
  ensureScript().then(() => {
    const opts = optionsToJs(options);

    opts.oncomplete = function (data) {
      onComplete(convertAddress(data));
    };

    if (onClose instanceof Some) {
      opts.onclose = function (state) {
        onClose[0](state);
      };
    }

    if (onSearch instanceof Some) {
      opts.onsearch = function (data) {
        onSearch[0](data.q, data.count);
      };
    }

    const instance = new daum.Postcode(opts);
    const openParams = {};
    setIf(openParams, "q", options.query);
    setIf(openParams, "autoClose", options.auto_close);
    setIf(openParams, "left", options.left);
    setIf(openParams, "top", options.top);
    setIf(openParams, "popupTitle", options.popup_title);
    setIf(openParams, "popupKey", options.popup_key);

    instance.open(openParams);
  });
}

export function do_embed(selector, options, onComplete, onClose, onResize, onSearch) {
  ensureScript().then(() => {
    // React useId()가 생성하는 ":r0:" 같은 콜론 포함 ID를 안전하게 처리
    const element = selector.startsWith("#")
      ? document.getElementById(selector.slice(1))
      : document.querySelector(selector);
    if (!element) return;

    const opts = optionsToJs(options);

    opts.oncomplete = function (data) {
      onComplete(convertAddress(data));
    };

    if (onClose instanceof Some) {
      opts.onclose = function (state) {
        onClose[0](state);
      };
    }

    if (onResize instanceof Some) {
      opts.onresize = function (size) {
        onResize[0](size.width, size.height);
      };
    }

    if (onSearch instanceof Some) {
      opts.onsearch = function (data) {
        onSearch[0](data.q, data.count);
      };
    }

    const instance = new daum.Postcode(opts);
    const embedParams = {};
    const q = fromOpt(options.query);
    const autoClose = fromOpt(options.auto_close);
    if (q !== undefined) embedParams.q = q;
    if (autoClose !== undefined) embedParams.autoClose = autoClose;

    instance.embed(element, embedParams);
  });
}
