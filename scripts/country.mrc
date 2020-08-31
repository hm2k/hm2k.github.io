;.oO{ Country 0.2 by HM2K }Oo. - IRC@HM2K.ORG

;Installation: Make sure country.mrc is in your $mircdir then type: /load -rs country.mrc

alias countrys {
  if ($right($1,4) == name) { return Name }
  if ($right($1,4) == info) { return Information }
  if ($right($1,3) == com) { return Commercial }
  if ($right($1,3) == net) { return Network }
  if ($right($1,3) == org) { return Organization }
  if ($right($1,3) == edu) { return Educational }
  if ($right($1,3) == gov) { return Government }
  if ($right($1,3) == mil) { return Military }
  if ($right($1,3) == int) { return International }
  if ($right($1,3) == rpa) { return Arpanet }
  if ($right($1,3) == ato) { return Nato field }
  if ($right($1,3) == biz) { return Business }
  if ($right($1,2) == ad) { return Andorra }
  if ($right($1,2) == ae) { return United Arab Emirates }
  if ($right($1,2) == af) { return Afghanistan }
  if ($right($1,2) == ag) { return Antigua and Barbuda }
  if ($right($1,2) == ai) { return Anguilla }
  if ($right($1,2) == al) { return Albania }
  if ($right($1,2) == am) { return Armenia }
  if ($right($1,2) == an) { return Netherlands Antilles }
  if ($right($1,2) == ao) { return Angola }
  if ($right($1,2) == aq) { return Antarctica }
  if ($right($1,2) == ar) { return Argentina }
  if ($right($1,2) == as) { return American Samoa }
  if ($right($1,2) == at) { return Austria }
  if ($right($1,2) == au) { return Australia }
  if ($right($1,2) == aw) { return Aruba }
  if ($right($1,2) == az) { return Azerbaijan }
  if ($right($1,2) == ba) { return Bosnia/Herzegovina }
  if ($right($1,2) == bb) { return Barbados }
  if ($right($1,2) == bd) { return Bangladesh }
  if ($right($1,2) == be) { return Belgium }
  if ($right($1,2) == bf) { return Burkina faso }
  if ($right($1,2) == bg) { return Bulgaria }
  if ($right($1,2) == bh) { return Bahrain }
  if ($right($1,2) == bi) { return Burundi }
  if ($right($1,2) == bj) { return Benin }
  if ($right($1,2) == bm) { return Bermuda }
  if ($right($1,2) == bn) { return Brunei Darussalam }
  if ($right($1,2) == bo) { return Bolivia }
  if ($right($1,2) == br) { return Brazil }
  if ($right($1,2) == bs) { return Bahamas }
  if ($right($1,2) == bt) { return Bhutan }
  if ($right($1,2) == bv) { return Bouvet Island }
  if ($right($1,2) == bw) { return Botswana }
  if ($right($1,2) == by) { return Belarus }
  if ($right($1,2) == bz) { return Belize }
  if ($right($1,2) == ca) { return Canada }
  if ($right($1,2) == cc) { return Cocos Islands }
  if ($right($1,2) == cf) { return Central African Republic }
  if ($right($1,2) == cg) { return Congo }
  if ($right($1,2) == ch) { return Switzerland }
  if ($right($1,2) == ci) { return Cote d'Ivoire }
  if ($right($1,2) == ck) { return Cook Islands }
  if ($right($1,2) == cl) { return Chile }
  if ($right($1,2) == cm) { return Cameroon }
  if ($right($1,2) == cn) { return China }
  if ($right($1,2) == co) { return Colombia }
  if ($right($1,2) == cr) { return Costa Rica }
  if ($right($1,2) == cs) { return Former Czechoslovakia }
  if ($right($1,2) == cu) { return Cuba }
  if ($right($1,2) == cv) { return Cape Verde }
  if ($right($1,2) == cx) { return Christmas Island }
  if ($right($1,2) == cy) { return Cyprus }
  if ($right($1,2) == cz) { return Czech Republic }
  if ($right($1,2) == de) { return Germany }
  if ($right($1,2) == dj) { return Djibouti }
  if ($right($1,2) == dk) { return Denmark }
  if ($right($1,2) == dm) { return Dominica }
  if ($right($1,2) == do) { return Dominican Republic }
  if ($right($1,2) == dz) { return Algeria }
  if ($right($1,2) == ec) { return Ecuador }
  if ($right($1,2) == ee) { return Estonia }
  if ($right($1,2) == eg) { return Egypt }
  if ($right($1,2) == eh) { return Western Sahara }
  if ($right($1,2) == er) { return Eritrea }
  if ($right($1,2) == es) { return Spain }
  if ($right($1,2) == et) { return Ethiopia }
  if ($right($1,2) == fi) { return Finland }
  if ($right($1,2) == fj) { return Fiji }
  if ($right($1,2) == fk) { return Falkland Islands }
  if ($right($1,2) == fm) { return Micronesia }
  if ($right($1,2) == fo) { return Faroe Islands }
  if ($right($1,2) == fr) { return France }
  if ($right($1,2) == fx) { return Metropolitan France }
  if ($right($1,2) == ga) { return Gabon }
  if ($right($1,2) == gb) { return Great Britain }
  if ($right($1,2) == gd) { return Grenada }
  if ($right($1,2) == ge) { return Georgia }
  if ($right($1,2) == gf) { return French Guiana }
  if ($right($1,2) == gh) { return Ghana }
  if ($right($1,2) == gi) { return Gibraltar }
  if ($right($1,2) == gl) { return Greenland }
  if ($right($1,2) == gm) { return Gambia }
  if ($right($1,2) == gn) { return Guinea }
  if ($right($1,2) == gp) { return Guadeloupe }
  if ($right($1,2) == gq) { return Equatorial Guinea }
  if ($right($1,2) == gr) { return Greece }
  if ($right($1,2) == gs) { return South Georgia & South Sandwich Isls }
  if ($right($1,2) == gt) { return Guatemala }
  if ($right($1,2) == gu) { return Guam }
  if ($right($1,2) == gw) { return Guinea-bissau }
  if ($right($1,2) == gy) { return Guyana }
  if ($right($1,2) == hk) { return Hong Kong }
  if ($right($1,2) == hm) { return Heard & McDonald Islands }
  if ($right($1,2) == hn) { return Honduras }
  if ($right($1,2) == hr) { return Croatia }
  if ($right($1,2) == ht) { return Haiti }
  if ($right($1,2) == hu) { return Hungary }
  if ($right($1,2) == id) { return Indonesia }
  if ($right($1,2) == ie) { return Ireland }
  if ($right($1,2) == il) { return Israel }
  if ($right($1,2) == in) { return India }
  if ($right($1,2) == io) { return British Indian Ocean Territory }
  if ($right($1,2) == iq) { return Iraq }
  if ($right($1,2) == ir) { return Iran }
  if ($right($1,2) == is) { return Iceland }
  if ($right($1,2) == it) { return Italy }
  if ($right($1,2) == jm) { return Jamaica }
  if ($right($1,2) == jp) { return Japan }
  if ($right($1,2) == ke) { return Kenya }
  if ($right($1,2) == kg) { return Kyrgyzstan }
  if ($right($1,2) == kh) { return Cambodia }
  if ($right($1,2) == ki) { return Kiribati }
  if ($right($1,2) == km) { return Comoros }
  if ($right($1,2) == kn) { return St Kitts and Nevis }
  if ($right($1,2) == kp) { return North Korea }
  if ($right($1,2) == kr) { return South Korea }
  if ($right($1,2) == kw) { return Kuwait }
  if ($right($1,2) == ky) { return Cayman Islands }
  if ($right($1,2) == kz) { return Kazakhstan }
  if ($right($1,2) == la) { return Laos }
  if ($right($1,2) == lb) { return Lebanon }
  if ($right($1,2) == lc) { return Saint Lucia }
  if ($right($1,2) == li) { return Liechtenstein }
  if ($right($1,2) == lk) { return Sri Lanka }
  if ($right($1,2) == lr) { return Liberia }
  if ($right($1,2) == ls) { return Lesotho }
  if ($right($1,2) == lt) { return Lithuania }
  if ($right($1,2) == lu) { return Luxembourg }
  if ($right($1,2) == lv) { return Latvia }
  if ($right($1,2) == ly) { return Libya }
  if ($right($1,2) == ma) { return Morocco }
  if ($right($1,2) == mc) { return Monaco }
  if ($right($1,2) == md) { return Moldova }
  if ($right($1,2) == mg) { return Madagascar }
  if ($right($1,2) == mh) { return Marshall Islands }
  if ($right($1,2) == mk) { return Macedonia }
  if ($right($1,2) == ml) { return Mali }
  if ($right($1,2) == mm) { return Myanmar }
  if ($right($1,2) == mn) { return Mongolia }
  if ($right($1,2) == mo) { return Macau }
  if ($right($1,2) == mp) { return Northern Mariana Islands }
  if ($right($1,2) == mq) { return Martinique }
  if ($right($1,2) == mr) { return Mauritania }
  if ($right($1,2) == ms) { return Montserrat }
  if ($right($1,2) == mt) { return Malta }
  if ($right($1,2) == mu) { return Mauritius }
  if ($right($1,2) == mv) { return Maldives }
  if ($right($1,2) == mw) { return Malawi }
  if ($right($1,2) == mx) { return Mexico }
  if ($right($1,2) == my) { return Malaysia }
  if ($right($1,2) == mz) { return Mozambique }
  if ($right($1,2) == na) { return Namibia }
  if ($right($1,2) == nc) { return New Caledonia }
  if ($right($1,2) == ne) { return Niger }
  if ($right($1,2) == nf) { return Norfolk Island }
  if ($right($1,2) == ng) { return Nigeria }
  if ($right($1,2) == ni) { return Nicaragua }
  if ($right($1,2) == nl) { return Netherlands }
  if ($right($1,2) == no) { return Norway }
  if ($right($1,2) == np) { return Nepal }
  if ($right($1,2) == nr) { return Nauru }
  if ($right($1,2) == nt) { return Neutral Zone }
  if ($right($1,2) == nu) { return Niue }
  if ($right($1,2) == nz) { return New Zealand }
  if ($right($1,2) == om) { return Oman }
  if ($right($1,2) == pa) { return Panama }
  if ($right($1,2) == pe) { return Peru }
  if ($right($1,2) == pf) { return French Polynesia }
  if ($right($1,2) == pg) { return Papua New Guinea }
  if ($right($1,2) == ph) { return Philippines }
  if ($right($1,2) == pk) { return Pakistan }
  if ($right($1,2) == pl) { return Poland }
  if ($right($1,2) == pm) { return St Pierre & Miquelon }
  if ($right($1,2) == pn) { return Pitcairn }
  if ($right($1,2) == pt) { return Portugal }
  if ($right($1,2) == pw) { return Palau }
  if ($right($1,2) == py) { return Paraguay }
  if ($right($1,2) == qa) { return Qatar }
  if ($right($1,2) == re) { return Reunion }
  if ($right($1,2) == ro) { return Romania }
  if ($right($1,2) == ru) { return Russian Federation }
  if ($right($1,2) == rw) { return Rwanda }
  if ($right($1,2) == sa) { return Saudi Arabia }
  if ($right($1,2) == sb) { return Solomon Islands }
  if ($right($1,2) == sc) { return Seychelles }
  if ($right($1,2) == sd) { return Sudan }
  if ($right($1,2) == se) { return Sweden }
  if ($right($1,2) == sg) { return Singapore }
  if ($right($1,2) == sh) { return St Helena }
  if ($right($1,2) == si) { return Slovenia }
  if ($right($1,2) == sj) { return Svalbard & Jan Mayen Islands }
  if ($right($1,2) == sk) { return Slovak Republic }
  if ($right($1,2) == sl) { return Sierra Leone }
  if ($right($1,2) == sm) { return San Marino }
  if ($right($1,2) == sn) { return Senegal }
  if ($right($1,2) == so) { return Somalia }
  if ($right($1,2) == sr) { return Suriname }
  if ($right($1,2) == st) { return Sao Tome & Principe }
  if ($right($1,2) == su) { return Former USSR }
  if ($right($1,2) == sv) { return el Salvador }
  if ($right($1,2) == sy) { return Syria }
  if ($right($1,2) == sz) { return Swaziland }
  if ($right($1,2) == tc) { return Turks & Caicos Islands }
  if ($right($1,2) == td) { return Chad }
  if ($right($1,2) == tf) { return French Southern Territories }
  if ($right($1,2) == tg) { return Togo }
  if ($right($1,2) == th) { return Thailand }
  if ($right($1,2) == tj) { return Tajikistan }
  if ($right($1,2) == tk) { return Tokelau }
  if ($right($1,2) == tm) { return Turkmenistan }
  if ($right($1,2) == tn) { return Tunisia }
  if ($right($1,2) == to) { return Tonga }
  if ($right($1,2) == tp) { return East Timor }
  if ($right($1,2) == tr) { return Turkey }
  if ($right($1,2) == tt) { return Trinidad & Tobago }
  if ($right($1,2) == tv) { return Tuvalu }
  if ($right($1,2) == tw) { return Taiwan }
  if ($right($1,2) == tz) { return Tanzania }
  if ($right($1,2) == ua) { return Ukraine }
  if ($right($1,2) == ug) { return Uganda }
  if ($right($1,2) == uk) { return United Kingdom }
  if ($right($1,2) == um) { return US Minor Outlying Islands }
  if ($right($1,2) == us) { return United States }
  if ($right($1,2) == uy) { return Uruguay }
  if ($right($1,2) == uz) { return Uzbekistan }
  if ($right($1,2) == va) { return Vatican City State }
  if ($right($1,2) == vc) { return St Vincent & The Grenadines }
  if ($right($1,2) == ve) { return Venezuela }
  if ($right($1,2) == vg) { return British Virgin Islands }
  if ($right($1,2) == vi) { return US Virgin Islands }
  if ($right($1,2) == vn) { return Vietnam }
  if ($right($1,2) == vu) { return Vanuatu }
  if ($right($1,2) == wf) { return Wallis & Futuna Islands }
  if ($right($1,2) == ws) { return Samoa }
  if ($right($1,2) == ye) { return Yemen }
  if ($right($1,2) == yt) { return Mayotte }
  if ($right($1,2) == yu) { return Yugoslavia }
  if ($right($1,2) == za) { return South Africa }
  if ($right($1,2) == zm) { return Zambia }
  if ($right($1,2) == zr) { return Zaire }
  if ($right($1,2) == zw) { return Zimbabwe }
  else { return Unknown }
}
on *:text:!country *:#: msg $chan $nick $+ : $2 is $countrys($2)
alias country say $1 is $countrys($1)
